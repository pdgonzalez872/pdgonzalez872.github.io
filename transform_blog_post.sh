#!/bin/bash

echo "Starting"

file="$1"

tmp_file=$(mktemp)

echo "<div hidden id="id">add-name-like-this</div>" > "$tmp_file"
echo "<div hidden id="title">Some Title</div>" >> "$tmp_file"
echo "<div hidden id="author">Paulo Gonzalez</div>" >> "$tmp_file"
echo "<div hidden id="tags">some, tags, like, this</div>" >> "$tmp_file"

cat "$file" >> "$tmp_file"

sed -i '' 's|<p>|<p class="my-4">|g' "$tmp_file"
sed -i '' 's|<pre></code>|<pre><code>|g' "$tmp_file"
sed -i '' 's|<pre><code>|<pre class="text-xs"><code>|g' "$tmp_file"
sed -i '' 's|<h3>|<div class="text-2xl font-bold mt-6 mb-6">|g' "$tmp_file"
sed -i '' 's|</h3>|</div>|g' "$tmp_file"
sed -i '' 's|<li>|<li class="mb-2">|g' "$tmp_file"

mv "$tmp_file" "$file"

echo "Finished"
