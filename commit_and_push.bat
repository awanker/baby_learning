@echo off
echo 正在提交改动并推送到GitHub...
echo.

echo 添加所有改动到暂存区...
git add .

echo.
echo 提交改动...
git commit -m "Update math.dart: fix bird animation size and direction"

echo.
echo 拉取远程仓库内容...
git pull origin main --allow-unrelated-histories

echo.
echo 推送到GitHub...
git push -u origin main

echo.
echo 完成！
pause

