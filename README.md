<a href="https://github.com/lk-geimfari/remindme">
    <p align="center">
      <img src="https://raw.githubusercontent.com/lk-geimfari/remindme/master/media/logo.png">
    </p>
</a>


**Remindme** - is a simple application written in Erlang which will remind you anything you want. Just run it!

### Build
To run application just build:

```
➜ erl -make
➜ erl -pa ebin/
➜ erl
```

### Usage

```erlang 
%% Run
1> remindme_server:start().
<0.39.0>

%% Sublsicrbe
2> remindme_server:subscribe(self()).
{ok,#Ref<0.0.2.39>}

%% Deadline datetime
3> DateTime = {{2017,9,17},{20,0,0}}.                          
{{2017,9,17},{20,0,0}}

%% Add event
4> remindme_server:add_event("Sup", "test", DateTime).
ok

%% Listen
5> remindme_server:listen(5).
[]

%% Cancel event
6> remindme_server:cancel("Sup").
ok

%% Add new event
7> remindme_server:add_event("Sup sup", "test", DateTime).
ok

8> remindme_server:listen(2000).                                      
[{done, "Sup sup", "test"}]
```

### Thanks
Thanks for Fred Hebert for great book.