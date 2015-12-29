require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'create a new post' do
    post = Post.new
    post.title = '조은 글이다'
    post.body = '...'
    assert post.save
  end

  test 'cannot create a new post without title' do
    post = Post.new
    post.body = '...'
    assert_not post.save
  end

  test 'cannot create a new post without body' do
    post = Post.new
    post.title = 'xxx'
    assert_not post.save
  end
end
