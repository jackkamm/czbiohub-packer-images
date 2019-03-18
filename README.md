# packer-images

Repository for Biohub [packer images](https://www.packer.io/intro/getting-started/install.html) and a guide on how to use them.

# Existing Images

All AMIs are in the `us-west-2` (Oregon) region. The AMI name consists of the stable name along with datestamp (YYYY-MM-DD).

| Stable Name | Description |
| ----------- | ----------- |
| `czbiohub-ubuntu16` | Ubuntu with updates, `make`, `g++`, and `awscli` |
| `czbiohub-anaconda` | Ubuntu16 + Anaconda3 5.0.1 |
| `czbiohub-miniconda` | Ubuntu16 + Miniconda3 (Anaconda3 with fewer packages installed) - has 1000 gigabytes of storage at `/mnt/data` |
| `czbiohub-bowtie2` | Miniconda3 + latest Bowtie2 |
| `czbiohub-star-htseq` | Miniconda3 + latest STAR and HTSeq |
| `czbiohub-nanopore` | Miniconda3 + albacore and pomoxis |
| `czbiohub-specops` | Miniconda3 + some sequencing, assembly, and nanopore tools |
| `czbiohub-jupyter` | Miniconda3 with Jupyter installed, see below for instructions |
| `czbiohub-transrate` | Miniconda3 + Transrate |

The Miniconda AMI and those based on it have 1TB of storage located at `/mnt/data`.

## How to use the images

You can run the image with `aegea launch`. Some useful options:

* `--ami-tags Name=[stable image name]` to get the latest version of one of the above images
* Alternatively you can use `--ami [AMI ID]` to specify a particular Amazon machine image
* Use the option `--iam-role S3fromEC2` to give your instance the ability to download and upload from our S3 buckets
* `--instance-type` or `-t` specifies the size (CPUs, memory, etc) of the instance. See http://www.ec2instances.info for a useful guide to what is available

The last argument is the name of the **instance**, which you will use to access it. In this example I launch an instance of our base Ubuntu16 image on a `t2.micro` machine with access to S3, and I call the instance `jwebber-test`.

```shell
➜ aegea launch --iam-role S3fromEC2 --ami-tags Name=czbiohub-miniconda -t t2.micro  jwebber-test
Identity added: /Users/james.webber/.ssh/aegea.launch.james.webber.webber-mbp.pem (/Users/james.webber/.ssh/aegea.launch.james.webber.webber-mbp.pem)
{
  "instance_id": "i-00340f4353ceb0a91"
}
```

I can then use `aegea` to log on to the instance (the username for all of these images is `ubuntu`):

```shell
➜  aegea ssh ubuntu@jwebber-test
Warning: Permanently added the RSA host key for IP address '34.212.166.93' to the list of known hosts.
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-1041-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


ubuntu@jwebber-test:~$ aws s3 ls
... [ list of S3 Buckets ] ...
```

If you're done using an instance for now but don't want to shut it down yet, you can suspend it with `aegea stop [instance name]` and it won't use any resources or cost any money. You can use `aegea start [instance name]` to start it up again:

```shell
➜  aegea stop jwebber-test
... [some time later] ...
➜  aegea start jwebber-test
```

If you're completely finished with an instance, use `aegea terminate`:

```shell
➜  aegea terminate jwebber-test
```

Terminating an instance will get rid of any changes you made while you were using it, so make sure to upload your results to S3 or copy it to a local computer.

## Using the Jupyter image

You can launch a Jupyter notebook server on EC2 with our image and a few extra steps.

```shell
➜  aegea launch --ami-tags Name="czbiohub-jupyter" -t t2.micro jwebber-jupyter
➜  aegea ssh ubuntu@jwebber-jupyter
ubuntu@jwebber-jupyter:~$ jupyter notebook # might want to do this in a tmux session!
```

That command won't return as long as the server is running, so in a separate terminal:

```shell
➜  aegea ssh ubuntu@jwebber-jupyter -NL localhost:8899:localhost:8888
```

Again, this won't return as long as the connection is running. You will be able to access the server from a browser pointed at `localhost:8899`.

The password for the notebook is the same as the InnerHub Wifi.

## How to look at which images you have running

At the command line, run `aegea ls -t "Name=YOURUSERNAME"`, assuming that you create all your images with your username prefixed. For example, if I launched an image with:

```
aegea launch --iam-role S3fromEC2 --ami-tags Name=czbiohub-jupyter -t x1e.xlarge --duration-hours=8  olgabot-sourmash-juypter-v2
```

Then I would look for all images whose name starts with `olgabot`, using the filter `-t "Name=olgabot*"`:

```
$ aegea ls -t "Name=olgabot*"
```

This will output a table with your images:

```
┌───────────────────────────────────┬───────────────────┬──────────┬─────────────┬──────────────┬────────────────────────────────┬─────────────────────┬────────────────────────────────┬────────────────────┬────────────────────────────────┬────────────────────────────────┐
│name                               │id                 │state     │instance_type│launch_time   │public_dns_name                 │image_id             │tags                            │iam_instance_profile│security_groups                 │state_reason                    │
├───────────────────────────────────┼───────────────────┼──────────┼─────────────┼──────────────┼────────────────────────────────┼─────────────────────┼────────────────────────────────┼────────────────────┼────────────────────────────────┼────────────────────────────────┤
│olgabot-anaconda                   │i-0769b984684e5d027│stopped   │t2.micro     │6 months ago  │                                │ami-e358e09b         │Name=olgabot-anaconda, Owner=ol…│olgabot-s3readonly  │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-fastqc                     │i-08bac2c4bf7309ba4│stopped   │m1.small     │6 months ago  │                                │ami-e8931090         │Owner=olgabot, OwnerSSHKeyName=…│olgabot-s3readonly  │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-immcantation               │i-0b2037efa5bd788cb│stopped   │m4.4xlarge   │6 months ago  │                                │ami-f2d3638a         │SSHHostPublicKeyPart2=5EpabtCNQ…│olgabot-s3readonly  │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-seq2loc-transcript-assembly│i-0e9519d7358164d42│stopped   │m4.4xlarge   │4 months ago  │                                │ami-07ae551b4caeab951│SSHHostPublicKeyPart2=q6Twn7l5m…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-igrec-tabula-muris         │i-06232d6c485d75240│stopped   │m4.4xlarge   │3 months ago  │                                │ami-23de585b         │OwnerSSHKeyName=aegea.launch.ol…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-seq2loc-trinity            │i-01bf17bebccb358f4│stopped   │m4.4xlarge   │3 months ago  │                                │ami-23de585b         │OwnerSSHKeyName=aegea.launch.ol…│S3fromEC2           │R/RStudio Server and JupyterHub…│{"Code": "Client.UserInitiatedS…│
│olgabot-kmer-test                  │i-0cdaf8d09e3bd295a│stopped   │t2.micro     │3 months ago  │                                │ami-0fa1d59d2ce52fda9│Name=olgabot-kmer-test, SSHHost…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-maca10x                    │i-070fb2d57fd9440d8│stopped   │m4.large     │2 months ago  │                                │ami-23de585b         │OwnerSSHKeyName=aegea.launch.ol…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-mca                        │i-03688a6852d43b69c│stopped   │m4.large     │2 months ago  │                                │ami-23de585b         │Name=olgabot-mca, Owner=olgabot…│S3fromEC2           │R/RStudio Server and JupyterHub…│{"Code": "Client.UserInitiatedS…│
│olgabot-jupyter-test               │i-0612038d2b20f00e1│stopped   │t2.micro     │2 months ago  │                                │ami-0c3cba3e57b0ff9db│SSHHostPublicKeyPart2=TcAsW66tP…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-jupyter-test-v2            │i-0df694d02f830ac31│stopped   │t2.micro     │2 months ago  │                                │ami-0c87a068d01e92945│SSHHostPublicKeyPart2=6iBJKHUcK…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-vo                         │i-0d707bef4094b02f5│stopped   │m4.large     │2 months ago  │                                │ami-07524b1e061397104│Owner=olgabot, OwnerSSHKeyName=…│aegea.launch        │R/RStudio Server and JupyterHub…│{"Code": "Client.UserInitiatedS…│
│olgabot-reflow-t2.micro            │i-0953c7f907cbcdee4│stopped   │t2.micro     │1 month ago   │                                │ami-0ca9b875d308c994c│Owner=olgabot, SSHHostPublicKey…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-samplesheets               │i-0243460a649f9ff5c│stopped   │t2.large     │1 month ago   │                                │ami-23de585b         │SSHHostPublicKeyPart2=nvvfHQgkh…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-sourmash                   │i-0cd2a8555e36ba26d│stopped   │t2.large     │1 month ago   │                                │ami-23de585b         │Name=olgabot-sourmash, OwnerSSH…│S3fromEC2           │aegea.launch                    │{"Code": "Client.UserInitiatedS…│
│olgabot-sourmash-juypter           │i-0183b546ce4569e8b│terminated│t2.2xlarge   │2 weeks ago   │                                │ami-0ad74e6f318530872│Name=olgabot-sourmash-juypter, …│None                │                                │{"Code": "Client.UserInitiatedS…│
│olgabot-sourmash-juypter-v2        │i-0a1fb016f4480204e│running   │x1e.xlarge   │11 minutes ago│ec2-54-187-219-131.us-west-2.co…│ami-0ad74e6f318530872│Owner=olgabot, SSHHostPublicKey…│S3fromEC2           │aegea.launch                    │None                            │
└───────────────────────────────────┴───────────────────┴──────────┴─────────────┴──────────────┴────────────────────────────────┴─────────────────────┴────────────────────────────────┴────────────────────┴────────────────────────────────┴────────────────────────────────┘
```

# Workflow for making a new image

If you're having trouble with any of these steps, ask in #eng-support

0. clone the repo with `git clone https://github.com/czbiohub/packer-images.git`
0. create a branch
   * In the command line, you can type `git checkout -b [your branch name]`
0. copy an existing image file, e.g. `example.json`
   * Unless you have a good reason to avoid doing so, start from `czbiohub-miniconda-*` or an image deriving from there. That way you'll have a standardized environment for running scripts, installing tools, etc.
0. change "ami_name" and "ami_description" to something descriptive
   * For personal images, use the convention [USERNAME]-ami_name-[DATE]. See `example.json` for a template.
   * Shared images should start with `czbiohub`.
0. update the provisioner, build, run your instance, repeat until you're satisfied
0. push your branch and send a pull request
   * To push a branch, use `git push --set-upstream origin [your branch name]`
   * The branch should appear here on the [repository website](https://github.com/czbiohub/packer-images) and there will be a link to make a new Pull Request.
   * Describe your changes in the text box and (optionally) request reviewers.

## Building the images

To build an image you create, e.g. `bionode.json` use

```
packer build bionode.json
```

### `name conflicts` error

If you're debugging an image, you may run into a `name conflicts` error:

```
➜  packer build bionode.json
amazon-ebs output will be in this color.

==> amazon-ebs: Prevalidating AMI Name...
==> amazon-ebs: Error: name conflicts with an existing AMI: ami-0768d07f
Build 'amazon-ebs' errored: Error: name conflicts with an existing AMI: ami-0768d07f

==> Some builds didn't complete successfully and had errors:
--> amazon-ebs: Error: name conflicts with an existing AMI: ami-0768d07f

==> Builds finished but no artifacts were created.
```

This happens because our date convention for the name is YYYY-MM-DD, and so AMIs built on the same day will have the same name. Normally we don't rebuild images that often, but while you're debugging it can happen. When this is the case, use `-force` to skip the name checking:

```
➜  packer build -force bionode.json
```

## Tips and tricks

* The Packer instance might not be ready immediately. You can use `"pause_before": "30s"` in your provisioner to wait before trying to run commands.
* The inline shell won't run `.bashrc` and therefore doesn't have `conda` on the path. If you want to install a package using `conda install`, add `"export PATH=$HOME/anaconda/bin:$PATH"` to your list of shell commands.

## Why this repo?

If you put your templates in this repo, the data-science and CZI eng teams can help to do things like make updates, enforce best practices, etc.
