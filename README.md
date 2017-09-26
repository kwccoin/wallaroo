# Wallaroo

Wallaroo is a fast, scalable data processing engine that rapidly takes you from prototype to production by eliminating infrastructure complexity.

- [What is Wallaroo?][what is wallaroo section]
- [Status][status section]
- [Getting Started][getting started section]
- [Documentation][documentation section]
- [Getting Help][getting help section]
- [How to Contribute][contribute section]
- [License][license section]
- [Additional Links][additional links]
- [About this Repository][about this repository section]

## What is Wallaroo?

Wallaroo is an ultrafast and elastic data processing engine that rapidly takes you from prototype to production by making the infrastructure virtually disappear. We’ve designed it to handle demanding high-throughput, low-latency tasks where the accuracy of results is essential. Wallaroo takes care of mechanics of scaling, resilience, state management, and message delivery. We've designed Wallaroo to make it easy scale applications with no code changes, and allow programmers to focus on business logic. You can learn more about Wallaroo from our ["Hello Wallaroo!" blog post][hello wallaroo post].

### Features

- State Management
- Scale running stateful applications with zero downtime
- Resilience in the face of failures
- Exactly-once message processing

### Language Bindings

Existing language bindings: 

- Python 2.7
- C++
- Pony

Planned Language bindings:

- Python 3
- Go
- JavaScript

Please see [status][status section] for language binding support details. Wallaroo is open source software with an expanding software community. Please see the [How to Contribute][contribute section] section if you wish to help support your favorite data analysis language.

### Supported platforms

- Linux
- MacOS

Wallaroo is open source software with an expanding software community. Please see the [How to Contribute][contribute section] section if you wish to help support your favorite operating system.

### Deployment model

Wallaroo applications are user hosted. It's equally at home "in the cloud" or "on-premise."

We have no "as a service" offering at this time. 

### Roadmap

Interested in where we are taking Wallaroo? Check out our [roadmap][roadmap].

## Status

### Language bindings

- Pony

Wallaroo is primarily written in Pony. As such, Pony is the first language to receive support for any given feature. We don't expect the Pony API to get much usage outside of Wallaroo Labs. We aren't maintaining any documentation for the Pony API outside of a [few examples][pony examples]. You are welcome to use the Pony API but are going to mostly be on your own documentation wise.

- Python 2.7

Currently, Python 2.7 is our primary focus. As we add features to the Wallaroo, we will be adding corresponding Python APIs and documentation.

- Python 3

We are currently working with a client who needs Python 3 bindings. We plan to introduce Python 3 bindings by the end of 2017. 

- C++

C++ is currently unsupported and apps created with the C++ API will not build unless you checkout the `last-working-C++-commit` tag. If you are interested in using Wallaroo with C++, you should [contact us][contact us email]. We're happy to work with you.

C++ was our first non-Pony API. Since that time we have learned a lot about writing Wallaroo language bindings. We plan on revisiting the C++ API in the future to improve its ergonomics. New functionality added to Wallaroo is not currently being implemented in the C++ API. 

- Go

We are currently working with a client who needs Go bindings. We plan to introduce Go bindings by the end of 2017. 

- JavaScript 

JavaScript support is currently in the planning stages with a release in 2018.

### Limitations

We have [numerous issues open][open issues] to improve existing Wallaroo functionality. For a high-level overview, please see our [current limitations document][current limitations].

## Getting Started

Are you the sort who just wants to get going? Dive right into our [documentation][documentation website] then! It will get you up and running with Wallaroo.

## Documentation

Our primary documentation is hosted by GitBook at [http://docs.wallaroolabs.com][documentation website]. You can find additional information on our [community site][community website].

## Getting Help

- [Join us on Freenode in #wallaroo][IRC]. 
- [Join our developer mailing list][developer mailing list].
- [Commercial support][contact us email]

## How to Contribute

We're an open source project and welcome contributions. Trying to figure out how to get started? Drop us a line on [IRC][IRC] or the [developer mailing list][developer mailing list], and we can get you started.

Be sure to check out our [contributors guide][contributors guide] before you get started.

## License

Wallaroo is an open source project. All of the source code is available to you. However, not all of the Wallaroo source code is available under an "open source" license. 

Most of the Wallaroo code base is available under the [Apache License, version 2][apache 2 license]. Parts of Wallaroo are licensed under the [Wallaroo Community License Agreement][wallaroo community license]. The [Wallaroo Community License][wallaroo community license] is based on [Apache version 2][apache 2 license]. However, you should read it for yourself. Here we provide a summary of the main points of the [Wallaroo Community License Agreement][wallaroo community license].

- You can **run** all Wallaroo code in a non-production environment without restriction.
- You can **run** all Wallaroo code in a production environment for free on up to 3 server or 24 cpus.
- If you want to **run** Wallaroo Enterprise version features in production above 3 servers or 24 cpus, you have to obtain a license.
- You can **modify** and **redistribute** any Wallaroo code
- Anyone who uses your **modified** or **redistributed** code is bound by the same license and needs to obtain a Wallaroo Enterprise license to run on more than 3 servers or 24 cpus in a production environment. 

Please [contact us][contact us email] if you have any questions about licensing or Wallaroo Enterprise.

## Additional Links

- [Hello Wallaroo!][hello wallaroo post]

An introduction to Wallaroo.

- [What's the "Secret Sauce"][secret sauce post]

A look inside Wallaroo's excellent performance

- [Wallaroo Labs][wallaroo labs website]

The company behind Wallaroo.

- [Documentation][documentation website]

Wallaroo documentation.

- QCon NY 2016: [How did I get here? Building Confidence in a Distributed Stream Processor][qcon16 how did i get here]
- CodeMesh 2016:[How did I get here? Building Confidence in a Distributed Stream Processor][codemesh16 how did i get here]

Our VP of Engineering Sean T. Allen talks about one of the techniques we use to test Wallaroo.

- [Wallaroo Labs Twitter][twitter]

## About this Repository

Wallaroo currently exists as a mono-repo. All the source that makes Wallaroo go is in this repo. Let's take a quick walk through what you'll find in each top-level directory:

- book

Markdown source used to build [http://docs.wallaroolabs.com][documentation website]. [http://docs.wallaroolabs.com][documentation website] gets built from the latest commit to the `release` branch. There's also ["Wallaroo-Latest" documentation][unstable documentation website]. "Wallaroo-Latest" is built from master so it will be as up to date as possible. Be aware many of the external links in our documentation point to the `release` branch. "Wallaroo-Latest" is intended only for the most adventurous amongst us.

- cpp_api

Code for writing Wallaroo applications using C++. This is currently unsupported.

- examples

Wallaroo example applications in a variety of languages. Currently, only the Python API examples are supported. See [status section][status section] for details.

- giles

TCP utility applications that can stream data over TCP to Wallaroo applications and receive TCP streams from said applications. 

- lib

The Pony source code that makes up Wallaroo.

- machida

Python runner application. Machida embeds a Python interpreter inside a native Wallaroo binary and allows you to run applications using the Wallaroo Python API.

- monitoring hub

Source for the Wallaroo metrics UI.

- orchestration

Tools we use to create machines in AWS and other environments.

- testing

Tools we have written that are used to test Wallaroo.

- utils

End user utilities designed to make it easier to do various Wallaroo tasks like cleanly shut down a cluster.

[about this repository section]: #about-this-repository 
[additional links]: #additional-links
[apache 2 license]: https://www.apache.org/licenses/LICENSE-2.0
[codemesh16 how did i get here]: https://www.youtube.com/watch?v=6MsPDtpe2tg
[community website]: http://www.wallaroolabs.com/community
[contact us email]: mailto:hello@wallaroolabs.com
[contribute section]: #how-to-contribute
[contributors guide]: CONTRIBUTING.md
[current limitations]: LIMITATIONS.md
[developer mailing list]: https://groups.io/g/wallaroo
[documentation section]: #documentation
[documentation website]: http://docs.wallaroolabs.com
[getting help section]: #getting-help
[getting started section]: #getting-started
[hello wallaroo post]: https://blog.wallaroolabs.com/2017/03/hello-wallaroo/
[IRC]: https://webchat.oftc.net/?channels=wallaroo
[license section]: #license
[open issues]: https://github.com/WallarooLabs/wallaroo/issues
[pony examples]: examples/pony
[qcon16 how did i get here]: https://www.infoq.com/presentations/trust-distributed-systems
[roadmap]: ROADMAP.md
[secret sauce post]: https://blog.wallaroolabs.com/2017/06/whats-the-secret-sauce/
[status section]: #status
[twitter]: https://www.twitter.com/wallaroolabs
[unstable documentation website]: https://www.gitbook.com/book/wallaroo-labs/wallaroo-latest/details
[wallaroo community license]: LICENSE.md
[wallaroo labs website]: https://www.wallaroolabs.com
[what is wallaroo section]: #what-is-wallaroo

