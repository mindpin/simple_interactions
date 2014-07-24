# SimpleInteractions

基于`faye`的消息互动工具.

## 使用

在`Gemfile`添加:

```ruby
gem "simple_interactions", :github => "mindpin/simple_interactions", :tag => "v0.0.1"
```

运行:

```bash
$ bundle install
```

启动服务器:

```bash
$ bundle exec interaction_server
```

### 在项目服务端:

```ruby
require "simple_interactions"

class SomeController < ApplicationController

  #发出消息
  def some_action
  	request_interaction(current_user, "client_id", {:some_data => "data"}) #=> {:server_id => "server_id"}
  end
  
  #查询消息
  def another_action
    query_interaction("server_id") #=> {:client_id => ..., :server_id => ..., :user_id => ..., :data => ..., :consumed => ....}
  end
end
```

### 在客户端:

```html
<script type="text/javascript" src="http://localhost:9898/interactions/client.js"></script>
```

```javascript
var client = new Faye.Client('http://localhost:9898/interactions');

// 侦听
var subscription = client.subscribe('/users/$user_id'), function(message) {
  // 处理消息
});

// 取消侦听
subscription.cancel();

// 标记消息为已消费
var publication = client.publish('/messages/consuming', {server_id: 'server_id'});

publication.then(function() {
  alert('Message received by server!');
}, function(error) {
  alert('There was a problem: ' + error.message);
});

// 断开连接
client.disconnect()
```
