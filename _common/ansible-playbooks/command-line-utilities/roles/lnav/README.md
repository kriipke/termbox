# Ansible Role: lnav

Installs `lnav` system-wide. 

# Variables

- `prefix`
 - description: installation prefix
 - default: `/usr/local`
- `lnav_data_dir`
 - description: location for log file formats
 - default: `{{ prefix }}/share/lnav`

