import time
import yaml
import os

def create_essentials():
    settings = yaml.load(open("settings.yaml", 'r'), yaml.SafeLoader)
    db_name = settings["db_name"]
    db_user = settings["db_user"]
    db_host = settings["db_host"]
    db_port = settings["db_port"]
    backup_path = settings["backup_path"]
    filename = settings["filename"]
    filename = filename + "-" + time.strftime("%Y%m%d") + ".backup"
    command_str = str(db_host)+" -p "+str(db_port)+" -d "+db_name+" -U "+db_user
    return command_str, backup_path, filename


def backup_database(table_names=None):
    command_str,backup_path,filename = create_essentials()
    command_str = "pg_dump -h " + command_str

    if table_names is not None:
        for x in table_names:
            command_str = command_str +" -t "+x

    command_str = command_str + " -F c -b -v -f '"+backup_path+"/"+filename+"'"
    try:
        os.system(command_str)
        print("Backup completed")
    except Exception as e:
        print("!!Problem occured!!")
        print(e)