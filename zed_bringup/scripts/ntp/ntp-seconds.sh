#!/bin/bash
ntp_server=robot-time-server
ntp_opts="-qu"
ntp_bin_path="/usr/sbin"
ntp_bin="${ntp_bin_path}/ntpdate"
ntp_tmp_file="/tmp/ntp-seconds.tmp"
ntp_cmd="${ntp_bin} ${ntp_opts} ${ntp_server} >${ntp_tmp_file}"

parse_cmd='offset=$(awk "/stratum/{print \$3}" FS=", " ${ntp_tmp_file} | sed "s/offset //")'

offset=0
offset_allowed="0.2"
offset_diff=0

function get_ntp_offset() {
	if ! [[ -e "${ntp_bin}" ]]; then
		echo "${ntp_bin} not found" 1>&2
		return 1
	fi
	if ! [[ -x "${ntp_bin}" ]]; then
		echo "${ntp_bin} not executable" 1>&2
		return 1
	fi
	#if [[ $EUID -ne 0 ]]; then
	#	echo "Not executed with root permissions" 1>&2
	#	return 1
	#fi
	if ! eval "${ntp_cmd}"; then
		echo "Could not check time server" 1>&2
		return 1
	fi
	if ! eval  "${parse_cmd}"; then
		echo "Could not parse offset" 1>&2
		return 1
	fi
	if ! [[ "${offset}" =~ ^(-)?[0-9]+(.[0-9]+)?$ ]]; then
		echo "Offset is not a number" 1>&2
		return 1
	fi
	offset="${offset##-}"
	offset_diff="$(bc <<< "scale=2; ${offset_allowed}-${offset}")"
	
	if [[ "${offset_diff}" =~ ^\-.+$ ]]; then
		echo "Offset is bigger than ${offset_allowed}" 1>&2
		return 1
	fi
	echo "Time synchronized"
	return 0
}

get_ntp_offset
exit $?

