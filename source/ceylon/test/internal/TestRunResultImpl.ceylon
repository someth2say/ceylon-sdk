import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.collection {
    ArrayList
}

shared class TestRunResultImpl() satisfies TestRunResult {
    
    value resultsList = ArrayList<TestResult>();
    
    variable Integer runCounter = 0;
    variable Integer successCounter = 0;
    variable Integer errorCounter = 0;
    variable Integer failureCounter = 0;
    variable Integer skippedCounter = 0;
    variable Integer abortedCounter = 0;
    variable Integer startTimeMilliseconds = 0;
    variable Integer endTimeMilliseconds = 0;
    
    shared actual Integer runCount => runCounter;
    shared actual Integer successCount => successCounter;
    shared actual Integer errorCount => errorCounter;
    shared actual Integer failureCount => failureCounter;
    shared actual Integer skippedCount => skippedCounter;
    shared actual Integer abortedCount => abortedCounter;
    
    shared actual Boolean isSuccess => successCount != 0 && errorCount == 0 && failureCount == 0;
    
    shared actual Integer startTime => startTimeMilliseconds;
    shared actual Integer endTime => endTimeMilliseconds;
    shared actual Integer elapsedTime => endTime - startTime;
    
    shared actual TestResult[] results => resultsList.sequence();
    
    shared actual String string {
        value b = StringBuilder();
        b.append("TEST RESULTS").appendNewline();
        if (results.empty) {
            b.append("There were no tests!").appendNewline();
        } else {
            b.append("run:     ``runCount``").appendNewline();
            b.append("success: ``successCount``").appendNewline();
            b.append("failure: ``failureCount``").appendNewline();
            b.append("error:   ``errorCount``").appendNewline();
            b.append("skipped: ``skippedCount``").appendNewline();
            b.append("aborted: ``abortedCount``").appendNewline();
            b.append("time:    `` elapsedTime / 1000 ``s").appendNewline();
            b.appendNewline();
            if (isSuccess) {
                b.append("TESTS SUCCESS").appendNewline();
            } else {
                for (result in results) {
                    if ((result.state == TestState.failure || result.state == TestState.error) && result.description.children.empty) {
                        b.append(result.string).appendNewline();
                    }
                }
                b.appendNewline();
                b.append("TESTS FAILED !").appendNewline();
            }
        }
        return b.string;
    }
    
    shared object listener satisfies TestListener {
        
        shared actual void testRunStarted(TestRunStartedEvent event) => startTimeMilliseconds = system.milliseconds;
        
        shared actual void testRunFinished(TestRunFinishedEvent event) => endTimeMilliseconds = system.milliseconds;
        
        shared actual void testFinished(TestFinishedEvent event) => handleResult(event.result, true);
        
        shared actual void testError(TestErrorEvent event) => handleResult(event.result, false);
        
        shared actual void testSkipped(TestSkippedEvent event) => handleResult(event.result, false);
        
        shared actual void testAborted(TestAbortedEvent event) => handleResult(event.result, false);
        
        void handleResult(TestResult result, Boolean wasRun) {
            resultsList.add(result);
            if (result.state == TestState.success && result.description.children.empty) {
                successCounter++;
                runCounter += wasRun then 1 else 0;
            } else if (result.state == TestState.failure && result.exception exists) {
                failureCounter++;
                runCounter += wasRun then 1 else 0;
            } else if (result.state == TestState.error && result.exception exists) {
                errorCounter++;
                runCounter += wasRun then 1 else 0;
            } else if (result.state == TestState.skipped && result.exception exists) {
                skippedCounter++;
            } else if (result.state == TestState.aborted && result.exception exists) {
                abortedCounter++;
            }
        }
    }
}
