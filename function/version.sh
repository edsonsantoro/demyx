# Demyx x Santoro
# https://demyx.sh
# https://santoro.studio
#
# demyx version <product> <args>
#
demyx_version() {
    # Make sure product name isn't a flag
    if [[ "$2" == *"--"*"="* ]]; then
        demyx_die "$2 isn't a valid product name"
    fi
    while :; do
        case "$3" in
            --version=?*)
                DEMYX_PRODUCT_VERSION="${3#*=}"
                ;;
            --version=)
                demyx_die '--version can not be empty'
                ;;
            --new-version=?*)
                DEMYX_PRODUCT_NEW_VERSION="${3#*=}"
                ;;
            --new-version=)
                demyx_die '--new-version can not be empty'
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

    DEMYX_VERSION_CHECK="$(find /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET" -name "$DEMYX_PRODUCT_VERSION" || true)"
    if [[ -n "$DEMYX_VERSION_CHECK" ]]; then
        DEMYX_NEW_VERSION_CHECK="$(find /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET" -name "$DEMYX_PRODUCT_NEW_VERSION" || true)"
        if [[ -n "$DEMYX_NEW_VERSION_CHECK" ]]; then
            if [[ -n "$DEMYX_RUN_FORCE" ]]; then
                DEMYX_RM_CONFIRM=y
            else
                echo -en "\e[33m"
                echo -e "[WARNING] The product $DEMYX_TARGET with version $DEMYX_PRODUCT_NEW_VERSION already exists!"
                echo -e "[WARNING] Do you want to delete this version and recreate it?"
                read -rep  "[WARNING] All sites using this version will be affected. Do you want to delete it and recreate? [yY]: " DEMYX_RM_CONFIRM
                echo -en "\e[39m"
            fi
            if [[ "$DEMYX_RM_CONFIRM" != [yY] ]]; then
                demyx_die 'Cancel version creation'
            else
                demyx_echo 'Deleting version...'
                rm -r -f /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_NEW_VERSION"
                demyx_echo 'Recreating product version'
                cp /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION" /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_NEW_VERSION"
                demyx_echo 'Product version created'
                demyx_echo 'You can use demyx connect command to connect this product version with a domain'
            fi
            if [[ -n "$DEMYX_RUN_CLOUDFLARE" && -z "$DEMYX_EMAIL" && -z "$DEMYX_CF_KEY" ]]; then
                demyx_die 'Missing Cloudflare key and/or email, please run demyx help stack'
            fi
        else 
            demyx_echo 'Cloning product version...'
            cp /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_VERSION" /"$DEMYX_HOST_PRODUCTS_PATH"/"$DEMYX_TARGET"/"$DEMYX_PRODUCT_NEW_VERSION"
            demyx_echo 'Product version created'
            demyx_echo 'You can use demyx connect command to connect this product version with a domain'
        fi
    else
        demyx_die 'The specified product version to copy from does not exists'
    fi
}