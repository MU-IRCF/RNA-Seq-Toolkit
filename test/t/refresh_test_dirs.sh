if [ -f t/test_results.log ]
then
    echo "Removing old test restuls and resetting test directories"
    rm t/test_results.log
    rm -rf TestData_?

    echo "Checking out test data directories from git"
    git checkout TestData_1 TestData_2 TestData_3
fi
