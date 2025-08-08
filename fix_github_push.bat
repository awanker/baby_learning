@echo off
echo 正在解决GitHub推送冲突...
echo.

echo 拉取远程仓库内容...
git pull origin main --allow-unrelated-histories

echo.
echo 检查状态...
git status

echo.
echo 推送到GitHub...
git push -u origin main

echo.
echo 完成！
pause

