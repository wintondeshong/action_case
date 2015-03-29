# ActionCase

Implementation of use-case driven design for ruby projects. Keep your business logic in the right place!

Supports: Ruby 1.9.3 +

## Installation

Add this line to your application's Gemfile:

    gem 'action_case'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_case

## Usage

There are a variety of classes available to implement use-case driven design principles and patterns in your project.

### Creating use-case class

```ruby
# /app/use_cases/survey_exporter.rb
require "csv"

module UseCases
  module Surveys
    class SurveyExporter < ActionCase::Base

      def export_csv survey_id
        begin
          survey = resource.find(survey_id)

          return respond CSV.generate({}) { |csv|
            csv << [:id, :title, :created_at]
            survey.entries.each do |entry|
              csv << [entry.id, entry.title, entry.created_at]
            end
          }
        rescue Exception => exception
          log :error, exception.message
        end

        respond "Unable to export the survey due to errors", false
      end

      def resource
        Survey
      end

    end
  end
end
```

#### Items of note:
1. Injection of concrete implementation via 'resource'
2. Use of #resource in #export_csv method, not concrete implementation
3. Use of inherited respond method to handle both successful and error responses
4. While it isn't required, it is recommended to namespace your use-cases with a [matching folder structure](http://cl.ly/image/1K3U120I1k0j).

### Leveraging Use-case (perhaps in a Rails controller)

#### Generic Handler Syntax
In many cases, you'll only have one operation in a given use case. When that is the case, you can cut down on verbosity by using the generic handler syntax.
Format: ```[use_case_class_name_snake_cased]_[success_or_error]```

```ruby
# /app/controllers/surveys_controller.rb

class SurveyController < ActionController::Base

  # POST /surveys/:id/export
  def export
    UseCases::Surveys::SurveyExporter.new(self).export_csv params[:id]
  end

  def survey_exporter_success csv_output
    flash[:notice] = "Survey successfully exported!"
    send_data csv_output, type: "text/plain", filename: "survey-export.csv", disposition: "attachment"
  end

  def survey_exporter_error error_output
    flash[:alert] = "There were issues exporting the survey - #{error_output}"
  end

end
```

#### Items of note:
1. We set the controller as the listener for the use-case, via 'self'
2. SurveyController#export stays short, sweet and to the point.
3. We avoid coupling by using a very event-like callback (tell don't ask) communication pattern.

#### Explicit Handler Syntax
As your application scales and business rules change, you may have related but slightly different method signatures on a given use-case with each requiring different responses. In those cases the more verbose explicit handler syntax is necessary.
Format: ```[class_name_snake_cased]_[method_name_snake_cased]_[success_or_error]```

```ruby
# /app/controllers/surveys_controller.rb

class SurveyController < ActionController::Base

  # POST /surveys/:id/export
  def export
    UseCases::Surveys::SurveyExporter.new(self).export_csv params[:id]
  end

  def survey_exporter_export_csv_success csv_output
    flash[:notice] = "Survey successfully exported!"
    send_data csv_output, type: "text/plain", filename: "survey-export.csv", disposition: "attachment"
  end

  def survey_exporter_export_csv_error error_output
    flash[:alert] = "There were issues exporting the survey - #{error_output}"
  end

end
```
#### Items of note:
1. The expanded method signatures including the ```_export_csv``` component


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
