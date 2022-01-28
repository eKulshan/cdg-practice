# frozen_string_literal: true

# REPORT
# Class Router managing directing (routing) of client requests to the right controller (handler).
# Mimics HTTP server. Takes instructions in the shape of HTTP verbs as arguments and directs instructions to the corresponding controller for handling.
# Module Resource mixes into controller classes by 'extend' instruction since routing is not a part of a specific instance, but to the class as a whole.

module Resource
  def connection(routes)
    if routes.nil?
      puts "No route matches for #{self}"
      return
    end

    loop do
      print 'Choose verb to interact with resources (GET/POST/PUT/DELETE) / q to exit: '
      verb = gets.chomp
      break if verb == 'q'

      unless routes.key?(verb)
        puts 'There is no such verb. Please choose from available verbs.'
        return
      end

      action = nil
      if verb == 'GET'
        print 'Choose action (index/show) / q to exit: '
        action = gets.chomp
        break if action == 'q'

        unless routes['GET'].key?(action)
          puts 'There is no such action. Please choose from available actions.'
          return
        end
      end

      action.nil? ? routes[verb].call : routes[verb][action].call
    end
  end
end

class PostsController
  extend Resource

  def initialize
    @posts = []
  end

  def index
    @posts.map.with_index { |post, i| puts "#{i}. #{post}" }
  end

  def show
    print 'Please enter post id: '
    id = gets.to_i
    post = @posts[id]
    if post.nil?
      puts "There is no post with id = #{id}. Choose index to see existing posts"
      return
    end
    puts "#{id}. #{post}"
  end

  def create
    print 'Please enter post text: '
    text = gets.to_s
    id = @posts.push(text).size - 1
    puts "#{id}. #{@posts[id]}"
  end

  def update
    print 'Please enter post id: '
    id = gets.to_i
    post = @posts[id]
    if post.nil?
      puts "There is no post with id = #{id}. Choose index to see existing posts"
      return
    end
    print 'Please post new text: '
    text = gets.to_s
    @posts[id] = text
    puts "#{id}. #{@posts[id]}"
  end

  def destroy
    print 'Please enter post id: '
    id = gets.to_i
    @posts.delete_at(id)
  end
end

class CommentsController
  extend Resource

  def initialize
    @comments = []
  end

  def index
    @comments.map.with_index { |comment, i| puts "#{i}. #{comment}" }
  end

  def show
    print 'Please enter comment id: '
    id = gets.to_i
    comment = @comments[id]
    if comment.nil?
      puts "There is no comment with id = #{id}. Choose index to see existing comments"
      return
    end
    puts "#{id}. #{comment}"
  end

  def create
    print 'Please enter comment text: '
    text = gets.to_s
    id = @comments.push(text).size - 1
    puts "#{id}. #{@comments[id]}"
  end

  def update
    print 'Please enter comment id: '
    id = gets.to_i
    comment = @comments[id]
    if comment.nil?
      puts "There is no comment with id = #{id}. Choose index to see existing comments"
      return
    end
    print 'Please comment new text: '
    text = gets.to_s
    @comments[id] = text
    puts "#{id}. #{@comments[id]}"
  end

  def destroy
    print 'Please enter comment id: '
    id = gets.to_i
    @comments.delete_at(id)
  end
end

class Router
  def initialize
    @routes = {}
  end

  def init
    resources(PostsController, 'posts')
    resources(CommentsController, 'comments')
    loop do
      print 'Choose resource you want to interact (1 - Posts, 2 - Comments, q - Exit): '
      choise = gets.chomp
      case choise
      when '1'
        PostsController.connection(@routes['posts'])
      when '2'
        CommentsController.connection(@routes['comments'])
      when 'q'
        break
      else
        puts 'There is no such resource. Please choose existing resource.'
      end
    end

    puts 'Good bye!'
  end

  def resources(klass, keyword)
    controller = klass.new
    @routes[keyword] = {
      'GET' => {
        'index' => controller.method(:index),
        'show' => controller.method(:show)
      },
      'POST' => controller.method(:create),
      'PUT' => controller.method(:update),
      'DELETE' => controller.method(:destroy)
    }
  end
end

router = Router.new

router.init
