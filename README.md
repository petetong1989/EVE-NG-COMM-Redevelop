# EVE-NG-RVO
This is redevelop of EVE-NG Community version 203.110. 

**It supports hot-plug, link style edit, link quality setup!** 

Not limited the number of user and role `Admin`, `Editor`, `User`.

Update 20201102
- [x] Fix 'stop all nodes' role verification
- [x] Add 'stop all nodes' response status viewable

Update 2020920

- [x] Link quality editable
- [x] Serial port link style editable
- [x] Fix a bit bugs

Update 2020928

- [x] Modify link quality apply mechanism
- [x] Tune up webUI of the lab view
- [x] Fix a bit bugs  

# Usage

1. Download the community version 203.110 from EVE-NG official or download it from the given link below

    **Download Link:** `https://pan.baidu.com/s/11Wa10xZ-2q6yGEvbHhr5FA`
    **PassCode:** `g6kh`

2. Clone my whole project via    

    ```shell

    $ git clone https://github.com/petetong1989/EVE-NG-RVO.git

    ```

3. Assign execute privilege for `deploy.sh` script and execute it.  

    ```shell

    $ cd EVE-NG-RVO
    $ sudo chmod +x deploy.sh
    $ ./deploy.sh

    ```

4. If no failed reported. congratulations! enjoy your lab!
    
    If any shit happen, you could follow this procedure below to rollback your code.

    - Change your directory to the git folder with command `cd <Where the folder is>`, typically the folder name is `EVE-NG-RVO`.
    - Use the command `git log` to check the recent commit. find out the commit version which you want to revert.
    - Use command `EXAMPLE: git reset --hard e66f2a7533225f4a40334ab57e7c24cbc0e39982`to revert specified version. 
    - And then, execute `deploy.sh` again.

5. If you want to update your version to current release. Just use `git pull` in your git folder (depends you not yet delete the folder).