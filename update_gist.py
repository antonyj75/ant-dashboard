import os
import datetime
import shutil


files_to_update = [ 'jobs/splunk_query_template.rb', 'jobs/splunk_query_list_example.rb', 'jobs/splunk_query_table_example.rb' ]
gist_location = '../gist-splunk-query'


if __name__ == '__main__':

    for srcfile in files_to_update:
        dt_repofile = datetime.datetime.fromtimestamp(os.path.getmtime(srcfile))
        file_name = os.path.split(srcfile)[1]
        destfile = os.path.join(gist_location, file_name)
        dt_gistfile = datetime.datetime.fromtimestamp(os.path.getmtime(destfile))

        print 'git repo ' + file_name + ' modified time: ' + dt_repofile.ctime()
        print 'gist ' + file_name + ' modified time: ' + dt_gistfile.ctime()

        if dt_gistfile < dt_repofile:
            print file_name + 'File at git repo is newer than the file at gist. Time to update the gist...'
            shutil.copy2(destfile, destfile + '.org')
            shutil.copy2(srcfile, destfile)
        elif dt_gistfile == dt_repofile:
            print 'Both files seem to be in sync.'
        else:
            print file_name + 'The file at the gist is newer. Who updated the gist?'

