import subprocess

gpg_output = subprocess.check_output(["gpg", "--list-public-keys", "--with-fingerprint", "--with-colons"]).splitlines()
fpr_lines = [line for line in gpg_output if line.startswith("fpr:")]

if len(fpr_lines) == 0:
	raise Exception("no gpg public key fingerprints found")

if len(fpr_lines) > 1:
	raise Exception("multiple gpg public key fingerprints found")

fpr = fpr_lines[0].split(":")[9]

with open(".jenkins/branches.yaml.in") as fin:
	with open("building/apt-branch-config/branches.yaml", "w") as fout:
		for line in fin:
			fout.write(line.replace("$$_SIGNING_KEY_$$", fpr))
