#!/bin/bash

SUBDIRS="libavcodec libavformat libavfilter"

for dir in $SUBDIRS; do
    while IFS='$\n' read -r line; do
        config=$(echo $line | cut -d= -f1 | xargs)
        objs=$(echo $line | cut -d= -f2)
        srcs=$(for obj in $objs; do
                echo ${obj%.o}.c
            done)

        can_compile=yes
        for file in $srcs; do
            if ! find $dir -name "$file" 2>/dev/null | grep . >/dev/null; then
                can_compile=no
                break
            fi
        done

        if [ $can_compile = "no" ]; then
            echo "Disabling $config"
            find android -type f -exec sed -i -e "s|^$config=yes|\!$config=yes|g" -e "s|$config 1|$config 0|g" {} \;
        else
            echo "Keeping $config"
        fi
    done < $dir/allconfigs
done

extra_disables="
CONFIG_WMV3_VAAPI_HWACCEL
CONFIG_AMV_DECODER
CONFIG_FFVHUFF_ENCODER
CONFIG_FFVHUFF_DECODER
CONFIG_FLV_ENCODER
CONFIG_FLV_DECODER
CONFIG_H263I_DECODER
CONFIG_H263P_ENCODER
CONFIG_H263P_DECODER
CONFIG_MPEG4_ENCODER
CONFIG_THP_DECODER
CONFIG_VC1IMAGE_DECODER
CONFIG_VP6A_DECODER
CONFIG_VP6F_DECODER
CONFIG_WMV3_DECODER
CONFIG_WMV3IMAGE_DECODER
CONFIG_AAC_LATM_DECODER
CONFIG_IAC_DECODER
CONFIG_ASF_STREAM_MUXER
CONFIG_F4V_MUXER
CONFIG_IPOD_MUXER
CONFIG_ISMV_MUXER
CONFIG_MATROSKA_AUDIO_MUXER
CONFIG_MP4_MUXER
CONFIG_MPEGTSRAW_DEMUXER
CONFIG_MXF_D10_MUXER
CONFIG_MXF_OPATOM_MUXER
CONFIG_PSP_MUXER
CONFIG_RTP_DEMUXER
CONFIG_SLN_DEMUXER
CONFIG_SPX_MUXER
CONFIG_TG2_MUXER
CONFIG_TGP_MUXER
"

for config in $extra_disables; do
    echo "Disabling $config"
    find android -type f -exec sed -i -e "s|^$config=yes|\!$config=yes|g" -e "s|$config 1|$config 0|g" {} \;
done
