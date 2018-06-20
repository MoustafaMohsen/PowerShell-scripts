echo "------------------ Current Status ------------------"
git status
echo "------------------ Staging Files------------------"
git add *
echo "------------------ Commiting ------------------"
$commit = Read-Host 'Please enter commit message'
& git commit -am $commit
echo "------------------ Pushing ------------------"
git push
pause