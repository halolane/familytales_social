require 'spec_helper'

describe "stories/edit" do
  before(:each) do
    @story = assign(:story, stub_model(Story,
      :title => "MyString",
      :subtitle => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit story form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", story_path(@story), "post" do
      assert_select "input#story_title[name=?]", "story[title]"
      assert_select "input#story_subtitle[name=?]", "story[subtitle]"
      assert_select "textarea#story_body[name=?]", "story[body]"
    end
  end
end
