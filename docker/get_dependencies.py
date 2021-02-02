import sys
import yaml
import logging

packages = {}

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(message)s',
    handlers=[ logging.StreamHandler() ]
)

# Get the packages from each relevant area in the snapcraft.yaml file
with open('../snap/snapcraft.yaml', 'r') as file:
    try:
        config = yaml.safe_load(file)
    except yaml.YAMLError as exc:
        logging.exception("Error parsing yaml: %s", exc)
        sys.exit(1)
    parts = config['parts']
    for part, spec in parts.items():
        try:
            bpkgs = spec['build-packages']
        except KeyError:
            pass
        else:
            for pkg in spec['build-packages']:
                packages[pkg] = True
        try:
            bpkgs = spec['stage-packages']
        except KeyError:
            pass
        else:
            for pkg in parts[part]['stage-packages']:
                packages[pkg] = True
                
# Convert the dict to a list and sort it
packages_list = list( packages )
packages_list.sort()
logging.info("Extracted snap packages: %s", packages_list)
# Write the new list
fname = '_raspi/dependencies-apt.conf'
with open(fname, "w") as f:
    for pkg in packages_list:
        f.write("%s\n" % pkg)
logging.info("Successfully dumped snap dependancies to %s", fname)
