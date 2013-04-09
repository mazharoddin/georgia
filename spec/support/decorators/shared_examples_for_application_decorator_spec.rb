shared_examples "a decorator" do

  it {should respond_to(:pretty_created_at)}
  it {should respond_to(:pretty_updated_at)}
  it {should respond_to(:pretty_published_at)}
  it {should respond_to(:created_by_name)}
  it {should respond_to(:updated_by_name)}
  it {should respond_to(:published_by_name)}

  context 'when it has many contents' do
    it {should respond_to(:content)}
    it {should respond_to(:title)}
    it {should respond_to(:text)}
    it {should respond_to(:excerpt)}
    it {should respond_to(:keywords)}
    it {should respond_to(:image)}
  end
end