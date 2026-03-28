# Using a GPG Key #

Always use GPG to sign the commits that you make in code repositories, especially for shared projects like Open Source software. This means that each commit can be linked to the author.

To create a GPG key, run the gpg command in a terminal window. For example:

```shell
gpg --full-gen-key
```

GPG will prompt you for several options. Use these values:

- Select the RSA and RSA algorithm
- Choose a key length of 4096
- Accept the default option to have no expiration date foryour key
- Enter the same email address that you will use for codehosting sites, such as Codeberg or GitHub

Once you have created a GPG key, configure Git to use it.

First get the ID of the key:

```shell
gpg --list-secret-keys --keyid-format=long
```


This displays an output like this:
```shell
pub   rsa4096/C36CB86CB86B3716 2022-01-18 [SC]
      BF18AC2876178908D6E71267D36CB86CB86B3716
uid                 [ultimate] Anne Example <anne@example.org>
sub   rsa4096/B7BB94F0C9BA6CAA 2022-01-18 [E]
```
In this example, the key ID is C36CB86CB86B3716.

Next, configure Git to use this key:

```shell

git config --global user.signingkey C36CB86CB86B3716
git config --global commit.gpgsign true

```

Finally, add your GPG key to your accounts on code hosting services that you use:

- [Codeberg](https://docs.codeberg.org/security/gpg-key/)
- [GitLab](https://docs.gitlab.com/ee/user/project/repository/signed_commits/gpg.html#add-a-gpg-key-to-your-account)
- [GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)

If you use multiple code hosting services for your projects, use the same GPG key for all of them. This ensures that copies of the same commits can be verified everywhere.
