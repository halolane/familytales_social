require 'spec_helper'

describe "stories/new" do
  before(:each) do
    assign(:story, stub_model(Story,
      :title => "MyString",
      :subtitle => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new story form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", stories_path, "post" do
      assert_select "input#story_title[name=?]", "story[title]"
      assert_select "input#story_subtitle[name=?]", "story[subtitle]"
      assert_select "textarea#story_body[name=?]", "story[body]"
    end
  end
end
