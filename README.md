# Amaze Hands [![Code Climate](https://codeclimate.com/github/fredwu/amaze_hands/badges/gpa.svg)](https://codeclimate.com/github/fredwu/amaze_hands) [![Travis CI](https://travis-ci.org/fredwu/amaze_hands.svg?branch=master)](https://travis-ci.org/fredwu/amaze_hands) [![Test Coverage](https://codeclimate.com/github/fredwu/amaze_hands/badges/coverage.svg)](https://codeclimate.com/github/fredwu/amaze_hands)

Amaze Hands is an amazing tool developed for analysing Kanban board cards, in a similar fashion to poker [hands](http://en.wikipedia.org/wiki/Glossary_of_poker_terms#hand) analysis.

Developed exclusively for the amazing Pricing squad in Group Platform at [REA](http://www.rea-group.com/).

![](doc/images/web_app.png)

## Why?

_Lorem ipsum spreadsheet amaze._

![](doc/images/spreadsheet.png)

## How?

_Lorem ipsum copy paste amaze._

        +---------------------+
        |        Text         | <- Raw text input.
        +----------+----------+
                   |
    +--------------v--------------+
    |         Strategies          |
    +-----------------------------+
    |   +---------------------+   |
    |   |       Parser        |   | <- Parses text into an AST.
    |   +----------+----------+   |
    |              |              |
    |   +----------v----------+   |
    |   |     Transformer     |   | <- Transforms the AST into a common AST.
    |   +---------------------+   |
    +--------------+--------------+
                   |
        +----------v----------+
        |       Builder       | <- Builds the dataset from the common AST.
        +----------+----------+
                   |
        +----------v----------+
        |       Reducer       | <- Filters the dataset.
        +----------+----------+
                   |
        +----------v----------+
        |      Analyser       | <- Analyses the dataset for metrics.
        +----------+----------+
                   |
        +----------v----------+
        |      Producer       | <- Produces metrics.
        +----------+----------+
                   |
        +----------v----------+
        |      Presenter      | <- Presents metrics.
        +---------------------+

## Supported Kanban Boards

- [LeanKit](http://leankit.com/)

## Stack

- Ruby 2.1+
- [Lotus Framework](http://lotusrb.org/)
- [Parslet](http://kschiess.github.io/parslet/) for [PEG](http://en.wikipedia.org/wiki/Parsing_expression_grammar)

## How to Use

### Run Metrics in CLI

```
bundle install
lotus c
```

```ruby
# in lotus repl
Workflow.new(
  strategy: Strategies::LeanKit,
  files:    Dir["#{__dir__}/db/cards/*.txt"]
).metrics
```

### Run Metrics in Local Web App

```
bundle install
lotus s
```

## Credits

- [Fred Wu](http://fredwu.me/) - author.
- [REA Group](http://www.rea-group.com/) - where Amaze Hands was built.

## License

Licensed under [MIT](http://fredwu.mit-license.org/)

![](doc/images/wow_amaze_hands.jpg)
