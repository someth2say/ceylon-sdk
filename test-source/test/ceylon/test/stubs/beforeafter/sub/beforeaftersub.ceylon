import test.ceylon.test.stubs.beforeafter {
    ...
}
import ceylon.test {
    ...
}

beforeTest
shared void beforeTest3() {
    callbackLogger.append("beforeTest3").appendNewline();
}

afterTest
shared void afterTest3() {
    callbackLogger.append("afterTest3").appendNewline();
}

shared interface BarWithCallbacksInterface1 satisfies BarWithCallbacksInterface2 {
    
    beforeTest
    shared default void bar1Before() {
        callbackLogger.append("BarWithCallbacksInterface1.bar1Before").appendNewline();
    }
    
    afterTest
    shared default void bar1After() {
        callbackLogger.append("BarWithCallbacksInterface1.bar1After").appendNewline();
    }
     
}

shared interface BarWithCallbacksInterface2 {
    
    beforeTest
    shared default void bar2Before() {
        callbackLogger.append("BarWithCallbacksInterface2.bar2Before").appendNewline();
    }
    
    afterTest
    shared default void bar2After() {
        callbackLogger.append("BarWithCallbacksInterface2.bar2After").appendNewline();
    }
    
}

shared class BarWithCallbacks() extends TestWithCallbacks() satisfies BarWithCallbacksInterface1 {
    
    beforeTest
    shared void barBefore() {
        callbackLogger.append("BarWithCallbacks.barBefore").appendNewline();
    }
    
    afterTest
    shared void barAfter() {
        callbackLogger.append("BarWithCallbacks.barAfter").appendNewline();
    }
    
    test
    shared void bar() {
        callbackLogger.append("BarWithCallbacks.bar").appendNewline();
    }
    
}