Biz.configure do |config|
  config.time_zone = 'Australia/Melbourne'

  config.hours = {
    mon: { '00:00' => '24:00' },
    tue: { '00:00' => '24:00' },
    wed: { '00:00' => '24:00' },
    thu: { '00:00' => '24:00' },
    fri: { '00:00' => '24:00' }
  }

  config.holidays = [
    Date.new(2015, 02, 19),
    Date.new(2015, 02, 20),
    Date.new(2015, 02, 23),
    Date.new(2015, 04, 01)
  ]
end
