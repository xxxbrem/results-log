#!/bin/bash

cp -r ../snow-spider-agent/methods/spider-self-refine/output ./

# 配置部分
TARGET_DIR="./"    # 需要push的文件夹路径
COMMIT_MESSAGE="Auto commit and push at $(date +"%Y-%m-%d %H:%M:%S")"

# 切换到目标目录
cd "$TARGET_DIR" || exit

# 确保是一个 Git 仓库
if [ ! -d .git ]; then
    echo "Error: $TARGET_DIR is not a Git repository."
    exit 1
fi

# 拉取最新更改（可选）
git pull origin main --rebase || echo "Git pull failed. Continuing..."

# 添加所有更改
git add .

# 检查是否有更改需要提交
if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

# 提交更改
git commit -m "$COMMIT_MESSAGE"

# 推送到远程仓库
git push || echo "Git push failed. Check your network or credentials."
