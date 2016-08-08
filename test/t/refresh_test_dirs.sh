if [ -f t/test_results.log ]
then
    echo "Removing old test results and resetting test directories"
    rm t/test_results.log
    rm -rf TestData_?
    
    echo "Checking out test data directories from git"
    git checkout TestData_1 TestData_2 TestData_3

    # cp -r gzipped_TestData_3.orig TestData_3_gzipped
fi
