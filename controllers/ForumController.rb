class ForumController < ApplicationController

  get ('/') do
    #displaying all the posts
    @posts = Post.all
    erb :all_post
  end

  get ('/new') do
    erb :new_post
  end

  post ('/new') do
    new_post = Post.new
    new_post.title = params[:title]
    new_post.content = params[:content]
    logged_in_user = User.find_by ({ :username => session[:username] })
    new_post.author = logged_in_user.username
    new_post.img = logged_in_user.img
    new_post.user_id = logged_in_user.id
    new_post.save
    
    redirect '/posts'
  end

    
    get ('/your-posts') do
      #grabbing the user that is logged in
      user = User.find_by ({ :username => session[:username] })
      #displaying all the posts by the logged in user
      @posts = user.posts

      erb :user_posts
    end

      get  '/:id' do
      # grabbing all the posts
      @post = Post.find params[:id]
      erb :post_show

      end

      delete '/:id' do
        post = Post.find params[:id]
        # access the comments
        comments = post.comments
        #looping through the array to destroy the relationship
        comments.each do |relation|
          relation.destroy
        end
        #deleting the post
        post.destroy
        #updating the sessiongs
        session[:message] = {
          success: true,
          status: "good",
          message: "Successfully destroyed post ##{post.id}"
        }
        redirect "/days"
        

      end

      post '/:id/comments' do
        #grabbing the post by Id
        found_post = Post.find params[:id]
        #creating a new comment
        new_comment = Comment.new 
        #storing the inputs
        new_comment.comment = params[:comment]
        #storing the post id's in the comment
        new_comment.post_id= found_post.id
        #finding the logged in user
        logged_in_user = User.find_by ({ :username => session[:username] })
        #storing the logged in users name to the comment
        new_comment.author = logged_in_user.author
        #storing the user id to the comment
        new_comment.user_id = logged_in_user.id
        #saving the new comment
        new_comment.save
        #redirecting to all the posts
        redirect '/posts'

    end
end