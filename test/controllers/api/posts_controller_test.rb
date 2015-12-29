require 'test_helper'

class Api::PostsControllerTest < ActionDispatch::IntegrationTest
  test 'get posts' do
    Post.create(title: '조은 글', body: '냉무')
    get api_posts_url, params: { format: :json }
    assert response.body.include?('조은 글')
    assert_not response.body.include?('냉무')
  end

  test 'get the post' do
    post = Post.create(title: '조은 글', body: '냉무')
    get api_post_url(post.id), params: { format: :json }
    assert response.body.include?('조은 글')
    assert response.body.include?('냉무')
  end
end
