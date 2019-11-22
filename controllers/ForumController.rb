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
      puts "==============="
      puts @post.comment
      puts "^^^^^^^^^comments^^^^^^^^^^^^^^^^^"
      erb :post_show

      end

      delete '/:id' do
        post = Post.find params[:id]

        post.destroy

        session[:message] = {
          success: true,
          status: "good",
          message: "Successfully destroyed post ##{post.id}"
        }

        redirect "/days"
        

      end

      post '/:id' do
        found_post = Post.find params[:id]
        new_comment = Comment.new
        new_comment.comment = params[:comment]
        found_post.comment_id = new_comment.id

        logged_in_user = User.find_by ({ :username => session[:username] })

        new_comment.user_id = logged_in_user
          
        new_comment.save

        redirect '/posts'

        
      end

      

  


end