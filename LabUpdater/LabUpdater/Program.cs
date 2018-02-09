using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace LabUpdater
{
    class Program
    {

        private static FileProcessor fp = new FileProcessor();

        [STAThread]
        static void Main(string[] args)
        {

            Console.WriteLine("1. Single Lab");
            Console.WriteLine("2. All Labs");
            string response = Console.ReadLine();
            if(response == "1")
                fp.ExecuteUpdater();
            else if(response == "2")
                fp.UpdateAll();

            //Single lab Deployer
            //fp.ExecuteUpdater();


            //All lab deployer
            //fp.UpdateAll();
           

        }

       
    }
}
