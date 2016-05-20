use "collections"
use "buffy/messages"
use "net"
use "buffy/metrics"
use "time"

trait BasicStep
  be apply(input: StepMessage val)
  be add_step_reporter(sr: StepReporter val) => None

trait OutputStep
  be add_output(to: BasicStep tag)

trait ComputeStep[In: OSCEncodable] is BasicStep

trait ThroughStep[In: OSCEncodable val,
                  Out: OSCEncodable val] is (OutputStep & ComputeStep[In])

actor Step[In: OSCEncodable val, Out: OSCEncodable val] is ThroughStep[In, Out]
  let _f: Computation[In, Out]
  var _output: (BasicStep tag | None) = None
  var _step_reporter: (StepReporter val | None) = None

  new create(f: Computation[In, Out] iso) =>
    _f = consume f

  be add_step_reporter(sr: StepReporter val) =>
    _step_reporter = sr

  be add_output(to: BasicStep tag) =>
    _output = to

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[In] val =>
      match _output
      | let o: BasicStep tag =>
        let start_time = Time.millis()
        let output_msg =
          Message[Out](m.id, m.source_ts, m.last_ingress_ts, _f(m.data))
        o(output_msg)
        let end_time = Time.millis()
        match _step_reporter
        | let sr: StepReporter val =>
          sr.report(start_time, end_time)
        end
      end
    end

actor Source[Out: OSCEncodable val] is ThroughStep[String, Out]
  var _input_parser: Parser[Out] val
  var _output: (BasicStep tag | None) = None
  var _step_reporter: (StepReporter val | None) = None

  new create(input_parser: Parser[Out] val) =>
    _input_parser = input_parser

  be add_step_reporter(sr: StepReporter val) =>
    _step_reporter = sr

  be add_output(to: BasicStep tag) =>
    _output = to

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[String] val =>
      try
        let start_time = Time.millis()
        let output_msg: Message[Out] val =
          Message[Out](m.id, m.source_ts, m.last_ingress_ts, _input_parser(m.data))
        match _output
        | let o: BasicStep tag =>
          o(output_msg)
          let end_time = Time.millis()
          match _step_reporter
          | let sr: StepReporter val =>
            sr.report(start_time, end_time)
          end
        end
      else
        @printf[String]("Could not process incoming Message at source\n".cstring())
      end
    end

actor Sink[In: OSCEncodable val] is ComputeStep[In]
  let _f: FinalComputation[In]

  new create(f: FinalComputation[In] iso) =>
    _f = consume f

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[In] val =>
      _f(m.data)
    end

actor Partition[In: OSCEncodable val, Out: OSCEncodable val] is ThroughStep[In, Out]
  let _step_builder: StepBuilder[In, Out] val
  let _partition_function: PartitionFunction[In] val
  let _partitions: Map[I32, BasicStep tag] = Map[I32, BasicStep tag]
  var _output: (BasicStep tag | None) = None

  new create(s_builder: StepBuilder[In, Out] val, pf: PartitionFunction[In] val) =>
    _step_builder = s_builder
    _partition_function = pf

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[In] val =>
      let partition_id = _partition_function(m.data)
      if _partitions.contains(partition_id) then
        try
          _partitions(partition_id)(m)
        else
          @printf[String]("Can't forward to chosen partition!\n".cstring())
        end
      else
        try
          _partitions(partition_id) = _step_builder()
          match _partitions(partition_id)
          | let t: ThroughStep[In, Out] tag =>
            match _output
            | let o: BasicStep tag =>
              t.add_output(o)
            end
            t(m)
          end
        else
          @printf[String]("Computation type is invalid!\n".cstring())
        end
      end
    end

  be add_output(to: BasicStep tag) =>
    _output = to
    for key in _partitions.keys() do
      try
        match _partitions(key)
        | let t: ThroughStep[In, Out] tag =>
          match _output
          | let o: BasicStep tag =>
            t.add_output(o)
          end
        else
          @printf[String]("Partition not a ThroughStep!\n".cstring())
        end
      else
          @printf[String]("Couldn't find partition when trying to add output!\n".cstring())
      end
    end

actor StateStep[In: OSCEncodable val, Out: OSCEncodable val,
  State: Any #read] is ThroughStep[In, Out]
  var _step_reporter: (StepReporter val | None) = None
  let _state_computation: StateComputation[In, Out, State]
  var _output: (BasicStep tag | None) = None
  let _state: State

  new create(state_initializer: {(): State} val,
    state_computation: StateComputation[In, Out, State] iso) =>
    _state = state_initializer()
    _state_computation = consume state_computation

  be add_step_reporter(sr: StepReporter val) =>
    _step_reporter = sr

  be add_output(to: BasicStep tag) =>
    _output = to

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[In] val =>
      let res = _state_computation(_state, m.data)
      match _output
      | let o: BasicStep tag =>
        let start_time = Time.millis()
        let output_msg =
          Message[Out](m.id, m.source_ts, m.last_ingress_ts, consume res)
        o(output_msg)
        let end_time = Time.millis()
        match _step_reporter
        | let sr: StepReporter val =>
          sr.report(start_time, end_time)
        end
      end
    end

actor ExternalConnection[In: OSCEncodable val] is ComputeStep[In]
  let _stringify: {(In): String ?} val
  let _conn: TCPConnection
  let _metrics_collector: MetricsCollector tag

  new create(stringify: {(In): String ?} val, conn: TCPConnection,
    m_coll: MetricsCollector tag) =>
    _stringify = stringify
    _conn = conn
    _metrics_collector = m_coll

  be apply(input: StepMessage val) =>
    match input
    | let m: Message[In] val =>
      try
        let str = _stringify(m.data)
        @printf[String]((">>>>" + str + "<<<<\n").cstring())
        let tcp_msg = WireMsgEncoder.external(str)
        _conn.write(tcp_msg)
        _metrics_collector.report_boundary_metrics(BoundaryTypes.source_sink(),
          m.id, m.source_ts, Time.millis())
      end
    end