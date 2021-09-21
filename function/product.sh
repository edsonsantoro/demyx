# Demyx x Santoro
# https://demyx.sh
# https://santoro.studio
#
# demyx product <name> <args>
#
demyx_product() {
    # Make sure domain isn't a flag
    if [[ "$2" == *"--"*"="* ]]; then
        demyx_die "$2 isn't a valid product name"
    fi
    while :; do
        case "$3" in
            --version=?*)
                DEMYX_PRODUCT_VERSION="${3#*=}"
                ;;
            --version=)
                DEMYX_PRODUCT_VERSION=dev
                ;;
            --)
                shift
                break
                ;;
            -?*)
                printf '\e[31m[CRITICAL]\e[39m Unknown option: %s\n' "$3" >&2
                exit 1
                ;;
            *)
                break
        esac
        shift
    done
    
    if [[ "$DEMYX_PRODUCT_VERSION" = dev ]]; then
        echo -en "\e[33m" 
        read -rep  "[INFO] Product version not specified. Version name defaults to dev. Proceed? [yY]: " DEMYX_VERSION_CONFIRM
        echo -en "\e[39m"
    fi

    if [[ "$DEMYX_VERSION_CONFIRM" != [yY] ]]; then
        demyx_die 'Product creation canceled'
    else
        DEMYX_PRODUCT_CHECK="$(find /"$DEMYX_HOST_PRODUCTS_PATH" -name "$DEMYX_TARGET" || true)"
        if [[ -n "$DEMYX_PRODUCT_CHECK" ]]; then
            if [[ -n "$DEMYX_RUN_FORCE" ]]; then
                DEMYX_RM_CONFIRM=y
            else
                echo -en "\e[33m" 
                echo -e "[WARNING] The product $DEMYX_TARGET already exists!"
                echo -e "[WARNING] Do you want to delete this product with all its versions and recreate it?"
                read -rep  "[WARNING] All sites using this product and/or versions will be affected. Do you want to delete it and recreate? [yY]: " DEMYX_RM_CONFIRM
                echo -en "\e[39m"
            fi
            if [[ "$DEMYX_RM_CONFIRM" != [yY] ]]; then
                demyx_die 'Cancel product creation'
            else
                demyx_echo 'Deleting product and versions...'
                rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"
                demyx_echo 'Recreating product'
                mkdir -p /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"
                composer create-project roots/bedrock /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"
                rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/plugins
                rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/themes
                mv /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/mu-plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/mu-plugins
                ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/plugins
                ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/themes /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/themes
                ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/mu-plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/mu-plugins
                demyx_echo 'Product created'
                demyx_echo 'You can use demyx connect command to connect this product version with a domain'
            fi
            if [[ -n "$DEMYX_RUN_CLOUDFLARE" && -z "$DEMYX_EMAIL" && -z "$DEMYX_CF_KEY" ]]; then
                demyx_die 'Missing Cloudflare key and/or email, please run demyx help stack'
            fi
        else 
            demyx_echo 'Creating product...'
            mkdir -p /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"
            composer create-project roots/bedrock /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"
            rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/plugins
            rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/themes
            mv /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/mu-plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/mu-plugins
            ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/plugins
            ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/themes /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/themes
            ln -s /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/wp/wp-content/mu-plugins /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION"/web/app/mu-plugins
            demyx_echo 'Product version created'
            demyx_echo 'You can use demyx connect command to connect this product version with a domain'
        fi

        PRINT_TABLE="DEMYX^ WORDPRESS PRODUCT\n"
        PRINT_TABLE+="PRODUCT NAME^ ${DEMYX_TARGET}\n"
        PRINT_TABLE+="PRODUCT VERSION^ ${DEMYX_PRODUCT_VERSION}\n"
        PRINT_TABLE+="PRODUCT PATH^ /${DEMYX_HOST_INSTALL_PRODUCTS_PATH}/${DEMYX_TARGET}/${DEMYX_PRODUCT_VERSION}\n"
        PRINT_TABLE+="^\n"
        demyx_execute -v demyx_table "$PRINT_TABLE"
    fi
}