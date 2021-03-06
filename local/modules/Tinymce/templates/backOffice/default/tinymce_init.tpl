<script src="{url file='/tinymce/tinymce.min.js'}"></script>

<script>
    tinymce.init({
        selector: ".wysiwyg",

        theme: "modern",

        {loop type="module-config" name="dummy" module="tinymce" variable="editor_height" default_value="0"}
            // height of the editor zone
            {if $VALUE > 0}
                height: {$VALUE},
            {/if}
        {/loop}

        {loop type="module-config" name="dummy" module="tinymce" variable="show_menu_bar" default_value="0"}
            {if $VALUE == 0}
                menubar : false,
            {/if}
        {/loop}

        {loop type="module-config" name="dummy" module="tinymce" variable="force_pasting_as_text" default_value="0"}
            {if $VALUE != 0}
                // Force pasting as text
                paste_auto_cleanup_on_paste : true,
                paste_remove_styles: true,
                paste_remove_styles_if_webkit: true,
                paste_strip_class_attributes: true,
                paste_as_text: true,
        {/if}
        {/loop}

        // Use our smarty plugin to guess the best available language
        language: "{tinymce_lang}",

        // See available plugins at http://www.tinymce.com/wiki.php/Plugins
        plugins: [
            "advlist autolink link image lists charmap print preview hr anchor pagebreak",
            "searchreplace wordcount visualblocks visualchars insertdatetime media nonbreaking",
            "table contextmenu directionality emoticons paste textcolor responsivefilemanager",
            "fullscreen code youtube importcss"
        ],

        // See available controls at http://www.tinymce.com/wiki.php/Controls
        toolbar1: "undo redo | bold italic underline | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | hr | styleselect | filemanager | code | fullscreen",
        toolbar2: "link unlink anchor | image responsivefilemanager media youtube | forecolor backcolor | charmap | print preview ",

        image_advtab: true,

        {loop type="module-config" name="dummy" module="tinymce" variable="set_images_as_responsive" default_value="1"}
            {if $VALUE != 0}
            // Set image as responsive
            image_dimensions: false,
            image_class_list: [
                {
                    title: '{intl l='Responsive'}', value: 'img-responsive'
                },
                {
                    title: '{intl l='None'}', value: ''
                }
            ],
            {/if}
        {/loop}

        // File manager configuration
        external_filemanager_path: "{url file='/tinymce/filemanager/'}",
        filemanager_title: "{intl l='File manager' d='tinymce.bo.default'}" ,
        external_plugins: { "filemanager" : "{url file='/tinymce/filemanager/plugin.min.js'}"},

        // Styles (CSS or LESS) available in the editor could be defined in assets/css/editor.less file.
        {$css = ''}
        {stylesheets file='assets/css/editor.less' filters='less' source='Tinymce'}
        {$css = $asset_url}
        {/stylesheets}

        {stylesheets file='assets/css/custom-css.less' failsafe=true filters='less' source='Tinymce' template='default'}
            {if $asset_url != ''}
                {$css = "`$css`,`$asset_url`"}
            {/if}
        {/stylesheets}

        {if $css != ''}
            content_css: "{$css}",
            importcss_append: true,
        {/if}

        convert_urls: false,
        relative_urls : false,
        document_base_url : "{url path="/"}"
    });
</script>
