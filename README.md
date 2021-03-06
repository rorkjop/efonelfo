# EfoNelfo

[![Code Climate](https://codeclimate.com/github/rorkjop/efonelfo/badges/gpa.svg)](https://codeclimate.com/github/rorkjop/efonelfo)
[![Test Coverage](https://codeclimate.com/github/rorkjop/efonelfo/badges/coverage.svg)](https://codeclimate.com/github/rorkjop/efonelfo/coverage)
[![Build Status](https://travis-ci.org/rorkjop/efonelfo.svg?branch=master)](https://travis-ci.org/rorkjop/efonelfo)

Gem for parsing and writing EfoNelfo documents.

Supported EfoNelfo versions:

* 4.0

Supported formats:

* Bestilling (BH, BL, BT)
* Vareformat (VH, VL, VX, VA)
* Rabatt (RH, RL)
* Ordrebekreftelse (CH, CL, CT)

## Usage

Importing a CSV file:

    # EfoNelfo.load "B12345678.332.csv"          # => EfoNelfo::V40::VH

Parsing CSV:

    # EfoNelfo.parse "VH;EFONELFO;4.0;foo;bar"   # => EfoNelfo::V40::VH

Exporting CSV:

    # order = EfoNelfo::V40::VH.new
    # order.add EfoNelfo::V40::VL.new name: 'Something', price: 10
    # order.to_csv
    # => "VH;EFONELFO;4.0;;;;;;;;;;;;;;\r\nVL;;;Something;;;;;10;;;;;;;;;;;\r\n"


## TODO

* Export to json
* Support more filetypes
* Support more versions
* Support XML

## Resources

* http://www.efo.no/Portals/5/docs/ImplementasjonsGuide%20EFONELFO%204.0.pdf


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
