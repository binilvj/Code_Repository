"""
Scope of a varaible is local to the function or program unless a scope modifier is used
Scope Modifiers
Global: In each module that the variable should take global value, variable should be declared as Global
	Any change made in such a module with global scope will be availabe in other modules with global scope 
NonLocal: Any variable declared as Nonlocal has scope in enclosing modules as well
	  This is possible as long as there is no variable with same name with global scope in enclosing scope		In such case Nonlocal variable declaraion will throw an error 
"""
def scope_test():
    #global spam
    def do_local():
        spam = "local spam"
        print("Local to function:",spam)

    def do_nonlocal():
        nonlocal spam # works as long as enclosing scope has no global version of var
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"
   # print("calling program's local scope:",spam)
    spam = "test spam"
    do_local()
    print("After local assignment,but from enclosing scope:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

global spam
spam="unassigned"
print("calling program's local scope:",spam)
scope_test()
print("In global scope:", spam)
