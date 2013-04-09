require 'spec_helper'

describe Georgia::WidgetDecorator do

  subject {Georgia::WidgetDecorator.decorate(FactoryGirl.build(:widget))}

  it_behaves_like 'a decorator'

end