#!/bin/bash
# Entity Rename script. Written by cdracars 2012
#
# This script downloads the Drupal Model Module and renames the folder,
# files, and functions with user provided replacements.

echo "Please enter a new name for the entity."
read input_replace
echo "Please enter the modules page name."
read input_name
echo "Please enter the modules page description."
read input_desc
echo "Please enter the package you want you entity listed under."
read input_package
echo "Please enter the name listed on menus."
read input_menu

input_replace_lower=$( echo "${input_replace}" | awk '{print tolower($0)}' )
input_replace_caps=$( echo "${input_replace_lower}" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' )

input_menu_lower=$( echo "${input_menu}" | awk '{print tolower($0)}' )
input_menu_caps=$( echo "${input_menu_lower}" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' )

name='name = Model'

desc='Provides entity functionality as an example to use in your own development projects'

git clone https://github.com/cdracars/model.git

mv model $input_replace

cd $input_replace

for f in *; do
  mv $f `echo $f | sed 's/model\(.*\)/'$input_replace'\1/g'`;
done

cd views/

for f in *; do
  mv $f `echo $f | sed 's/model\(.*\)/'$input_replace_lower'\1/g'`;
done

mv $input_replace_lower\_handler_model_operations_field.inc $input_replace_lower\_handler_$input_replace_lower\_operations_field.inc

cd ..

sed -i "s/$name/name = $input_name/g" $input_replace_lower.info;
sed -i "s/$desc/$input_desc/g" $input_replace_lower.info;
sed -i "/$input_desc/ a\package = $input_package" $input_replace_lower.info;

sed -i "s/'title' => 'Models'/'title' => '$input_menu_caps'/g" $input_replace_lower.admin.inc;
sed -i "s/update models./update $input_menu_lower\s./g" $input_replace_lower.admin.inc;
sed -i "s/a model/a $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/no model/no $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/delete model/delete $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/model type/$input_menu_lower type/g" $input_replace_lower.admin.inc;
sed -i "s/new model/new $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/'interesting model/interesting $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/t('Model/t('$input_menu_caps/g" $input_replace_lower.admin.inc;
sed -i "s/Save model/Save $input_menu_lower/g" $input_replace_lower.admin.inc;
sed -i "s/'access arguments' => array('edit', 'edit ' . \$type->type),/'access arguments' => array('edit', \$type),/g" $input_replace_lower.admin.inc;

sed -i "s/this model/this $input_menu_lower/g" $input_replace_lower\_type.admin.inc;
sed -i "s/interesting model/interesting $input_menu_lower/g" $input_replace_lower\_type.admin.inc;
sed -i "s/Save model/Save $input_menu_lower/g" $input_replace_lower\_type.admin.inc;

#sed -i "/function model_access(/ a\  if (empty(\$account)) {\n    global \$user;\n    \$account = \$user;\n  }" $input_replace_lower.module;
sed -i "s/t('Model/t('$input_menu_caps/g" $input_replace_lower.module;
sed -i "s/Administer model/Administer $input_menu_lower/g" $input_replace_lower.module;
sed -i "s/for model/for $input_menu_lower/g" $input_replace_lower.module;
sed -i "s/any model/any $input_menu_lower/g" $input_replace_lower.module;

sed -i "s/\['title'\] = 'Models'/\['title'\] = '$input_menu_caps'/g" views/$input_replace_lower.views.inc;
sed -i "s/t('Model')/t('$input_menu_caps')/g" views/$input_replace_lower.views.inc;
sed -i "s/human_name = 'Model'/human_name = '$input_menu_caps'/g" views/$input_replace_lower.views.inc;
sed -i "s/No models/No $input_menu_lower\s/g" views/$input_replace_lower.views.inc;
sed -i "s/name = 'models'/name = '$input_menu_lower\s'/g" views/$input_replace_lower.views.inc;
#sed -i "s/\$views\\[\\] = \$view;/\$views[\$view->name] = \$view;/g" $input_replace_lower.views.inc;

find . -type f -exec sed -i 's/model/'$input_replace'/g' {} \;
find . -type f -exec sed -i 's/Model/'$input_replace_caps'/g' {} \;
find . -type f -exec sed -i 's/ModelType/'$input_replace_caps'Type/g' {} \;
find . -type f -exec sed -i 's/Model Type/'$input_replace_caps' Type/g' {} \;
find . -type f -exec sed -i 's/ModelController/'$input_replace_caps'Controller/g' {} \;
find . -type f -exec sed -i 's/ModelUIController/'$input_replace_caps'UIController/g' {} \;
find . -type f -exec sed -i 's/ModelTypeController/'$input_replace_caps'Controller/g' {} \;
find . -type f -exec sed -i "s/Manage model/Manage $input_menu_lower/g" {} \;
find . -type f -exec sed -i "s/all model/all $input_menu_lower/g" {} \;
find . -type f -exec sed -i "s/any model/any $input_menu_lower/g" {} \;

drush cc all
