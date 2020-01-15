# CPC-Ruby

The main purposes of this Ruby project: 
1. Encapsulate all my practical knowledge of Ruby into a **Living Document** of RSpec unit tests and Cucumber Features. 
1. Refine my TDD, BDD, and SBE-focused approach to solving problems.
1. Practise vital programming skills -- Git, information security, etc.

In short, it goes some way to answering the question, "*What problems can you solve, and how do you solve them in Ruby*"?

## Getting Started

1. Install Ruby 2.6.4
1. Clone this repository: https://github.com/clockworkpc/cpc-ruby.git
1. Navigate to the root directory of project.
1. Run `bundle install` in the command line to install the project gems.
1. To run the tests you have the following options:
  1. `bundle exec rspec` to run all the RSpec unit tests;
  1. `bundle exec cucumber` to run all the RSpec unit tests;
  1. `bundle exec guard` to run **Guard** in the background, which will run the RSpecs or Cucumber tests whenever a file is changed or saved, if you want to run a specific test,
  1. `bundle exec rspec {_spec.rb filepath}` to execute a specific RSpec file.
  1. `bundle exec cucumber {_.feature filepath}` to execute a specific Cucumber feature file.

### Note on Dotenv and Cpc::Toolkit::IsbnFetcher

This functionality requires the following:

1. A paid subscription to https://isbndb.com.
2. An authenticated API Key stored in the `.env` file:

    `ISBN_DB_API_KEY={your API key}`

Accordingly, Specs that require the above are ignored by the default *scope group* in the `Guardfile`.

### Note on Test Scope: Guard and Rake, RSpec and Cucumber

#### Guard

The `Guardfile` has the following *scope groups*:

1. `:offline` => runs Specs tagged `offline: true`. (Default)
2. `:online` => runs Specs tagged `online: true`.
3. `:online_extra` => runs Specs tagged `online: true` and `extra: true`

The `Guardfile` does not track Cucumber features, even though it could, because features should be tested by specific events, not merely by a change to the file.  This way, active development is done through TDD in RSpec, and when all the Specs pass, then I go back to the Feature.  Without this strict separation of concerns, RSpec and Cucumber will do each other's job.

#### Rake

The following Rake tasks are available if you want to run Specs and Features, with HTML reports:

```shell
$ bundle exec rake -T | grep -i "test"
rake test:all_tests                # Execute all Specs and Cucumber Features
rake test:offline_features         # Execute Cucumber features tagged @offline
rake test:offline_specs            # Execute all Specs tagged @offline, output to terminal
rake test:offline_specs_html       # Execute all Specs tagged @offline, output to HTML
rake test:offline_tests            # Execute all Specs and Cucumber Features tagged @offline
rake test:online_extra_features    # Execute Cucumber features tagged @online_extra
rake test:online_extra_specs       # Execute all Specs tagged @online_extra, output to terminal
rake test:online_extra_specs_html  # Execute all Specs tagged @online_extra, output to HTML
rake test:online_extra_tests       # Execute all Specs and Cucumber Features tagged @online_extra
rake test:online_features          # Execute Cucumber features tagged @online
rake test:online_specs             # Execute all Specs tagged @online, output to terminal
rake test:online_specs_html        # Execute all Specs tagged @online, output to HTML
rake test:online_tests             # Execute all Specs and Cucumber Features tagged @online
```

## Features of the Project

1. DRY **Ruby** code in `lib`
1. Test-driven development (TDD) provided with **RSpec** unit tests in `spec`,   
1. Behaviour-driven development (BDD) with Cucumber **Feature** and **Step** files in `feature`.
1. Namespacing and inheritance (`lib/cpc`)
1. Documentation (e.g. this `README`)
1. Management of dependencies with the `Gemfile`
1. Handling of events upon file system modifications with `guard`

## Workflow

1. Create `.feature` file in the `features` folder, wherein to define the problem and desired output in plain English [1], containing a large number of scenarios.
1. Run `cucumber` in the terminal and get the missing **Steps**
1. Create a `_steps.rb` file in the `feature/step_definitions` folder and define how the **Feature** inputs will be passed to the methods.
1. Create a `_spec.rb` file in the `spec` folder, and add as inputs and expectations a sample of the  those in the from the Cucumber **Feature**.
1. Create a `.rb` file in the `lib` folder:
  1. *Class*, if the functionality requires instantiation or to keep track of state.
  1. *Module* if the problem can be solved with static methods.
1. Apply TDD (Red-Green) until the RSpecs are satisfied.
1. Run `cucumber` on all the scenarios and make adjustments to the Ruby code or the RSpecs until all the scenarios in the **Feature** are satisfied.

[1] Gherkin tends to become more pseudo-code than English in real life, but it's a great tool for putting the big picture into words.  (And besides, that's what a lot of companies work with)

## Ruby code in `lib/cpc`

There are two main namespaces:
1. `Cpc::Util`
1. `Cpc::Toolkit`

`Cpc::Util` contains *Modules* whose methods are abstractions of generally useful things that I use in my day-to-day coding.

`Cpc::Toolkit` contains *Classes* that have the option of `include`-ing `Cpc::Util` *Modules*.  Each *Class* contains the functionality needed to solve a particular real-life problem.

As a further demonstration, there is a third namespace: `Cpc::Codewars`, which contains solutions to a few [Codewars](https://www.codewars.com) puzzles.  These are either *Modules* or *Classes*, as the above-described considerations require.

### Class vs Module

More for discipline than expedience, most of the Ruby files are Modules rather than Classes, in order to clarify whether my methods [really need to keep track of state](https://stackoverflow.com/questions/2671545/when-to-use-a-module-and-when-to-use-a-class).

To quote the excellent answer on Stack Overflow:

> A class should be used for functionality that will require instantiation or that needs to keep track of state. A module can be used either as a way to mix functionality into multiple classes, or as a way to provide one-off features that don't need to be instantiated or to keep track of state. A class method could also be used for the latter.
>
> With that in mind, I think the distinction lies in whether or not you really need a class. A class method seems more appropriate when you have an existing class that needs some singleton functionality. If what you're making consists only of singleton methods, it makes more sense to implement it as a module and access it through the module directly.

(Further thoughts anon)
