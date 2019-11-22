class ForumController < ApplicationController

  get ('/') do
    
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
    new_post.user_id = logged_in_user.id

    new_post.save
    
    redirect '/posts'
  end

    
    get ('/your-posts') do
      
      user = User.find_by ({ :username => session[:username] })
      @posts = user.posts

      erb :user_posts
    end

      get  '/:id' do
      
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

        session[:message] = {
          success: true,
          status: "good",
          message: "Successfully destroyed post ##{post.id}"
        }

        redirect "/days"
        

      end

      post '/:id/comments' do
        
        found_post = Post.find params[:id]

        new_comment = Comment.new 
        new_comment.comment = params[:comment]
        new_comment.post_id= found_post.id

        logged_in_user = User.find_by ({ :username => session[:username] })

        new_comment.user_id = logged_in_user
          
        new_comment.save

        redirect '/posts'

    end
end