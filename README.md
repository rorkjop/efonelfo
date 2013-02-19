# EfoNelfo

Supported versions:

* 4.0

Supported formats:

* Bestilling


## Usage

Importing a CSV file:

    # EfoNelfo.parse_csv "B12345678.332.csv"    # => EfoNelfo::Order

Making a CSV file (TODO):

    # order = EfoNelfo::Order.new
    # order.heads << EfoNelfo::V40::Order::Head.new customer_id: '123', foo: 'bar'
    # order.heads.last.lines << EfoNelfo::V40::Order::Line.new foo: '442', bar: '1123'
    # order.to_csv

## TODO

* Export to json
* Export to csv
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
