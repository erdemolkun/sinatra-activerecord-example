require "sinatra/base"
require "rack/protection"

require File.expand_path '../application.rb', __FILE__

use Rack::Session::Cookie, :secret => "!x#foo"
use Rack::Protection::FormToken
use Rack::Protection::EscapedParams
run MyApplication