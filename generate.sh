# Generate Website
# Author: Francisco Cornejo-Garcia (franciscornejog)

mkdir -p public public/posts
cp -r assets public/assets

# Generate public files for website with a given source and template
generate() {
  for source_file in $1; do
    target_file=${source_file/"content/"/} # remove content/ directory
    pandoc --template $2 $source_file -o public/${target_file%md}html; 
  done
}

generate "content/*.md" "templates/index"
generate "content/posts/*.md" "templates/posts"
