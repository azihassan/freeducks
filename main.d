import std.stdio;
import std.variant : Variant;

void main()
{

}

unittest
{
    struct Todo
    {
        string message;
        int priority;
    }

    struct State
    {
        Todo[] todos = [
            Todo("this is the first todo", 1)
        ];
        string message;
    }

    auto reducer = (State s, Action a) {
        switch(a.type)
        {
            case "add-todo":
                return State(s.todos ~ a.payload.get!Todo);
            break;
            case "change-message":
                return State(s.todos, a.payload.get!string);
            break;
            default:
                assert(false);
            break;
        }
        assert(false);
    };

    auto store = Store!(State)(reducer);

    store.dispatch(Action("add-todo", Variant(Todo("this is a new todo", 1))));
    assert(store.get().message == "");
    assert(store.get().todos == [
        Todo("this is the first todo", 1),
        Todo("this is a new todo", 1)
    ]);

    store.dispatch(Action("change-message", Variant("new message")));
    assert(store.get().message == "new message");
    assert(store.get().todos == [
        Todo("this is the first todo", 1),
        Todo("this is a new todo", 1)
    ]);
}

struct Store(State)
{
    private State _state;
    private State function(State state, Action action) reducer;

    this(State function(State state, Action action) reducer)
    {
        this.reducer = reducer;
    }

    State get() @property
    {
        return _state;
    }

    void dispatch(Action action)
    {
        _state = reducer(_state, action);
    }
}

struct Action
{
    string type;
    Variant payload;
}

//reactivity (observer pattern)
//store
//actions
//reducers
//action dispatching
