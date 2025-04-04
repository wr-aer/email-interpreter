# Build lambdas
for dir in lambdas/*/; do
    echo "Building lambda: $(basename "$dir")"
    cd "$dir"
    yarn build
done
