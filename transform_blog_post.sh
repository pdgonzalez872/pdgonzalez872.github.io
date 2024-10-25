#!/bin/bash

echo "Starting"

file="$1"

sed -i 's|<p>|<p class="my-4">|g' "$file"

sed -i 's|<pre></code>|<pre><code>|g' "$file"

sed -i 's|<pre><code>|<pre class="text-xs"><code>|g' "$file"

echo "Finished"
