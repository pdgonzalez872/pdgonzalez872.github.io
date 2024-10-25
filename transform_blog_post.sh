#!/bin/bash

echo "Starting"

file="$1"

sed -i '' 's|<p>|<p class="my-4">|g' "$file"
sed -i '' 's|<pre></code>|<pre><code>|g' "$file"
sed -i '' 's|<pre><code>|<pre class="text-xs"><code>|g' "$file"
sed -i '' 's|<h3>|<div class="text-2xl font-bold mt-6 mb-6">|g' "$file"
sed -i '' 's|</h3>|</div>|g' "$file"
sed -i '' 's|<li>|<li class="mb-2">|g' "$file"

echo "Finished"
