@echo off
echo 正在推送代码到GitHub...
echo.

echo 检查Git状态...
git status

echo.
echo 检查远程仓库...
git remote -v

echo.
echo 推送到GitHub...
git push -u origin main

echo.
echo 完成！
pause

