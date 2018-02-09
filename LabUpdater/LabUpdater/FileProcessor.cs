using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.NetworkInformation;
using System.Net;
using System.IO;
using System.Threading;

namespace LabUpdater
{
    class FileProcessor
    {

        private FolderBrowserDialog folderLocation;
        private bool hasExe = new bool();
        private bool pingSuccessful = false;
        private Ping ping = new Ping();
        private int maxRegs = 3;
        private PingReply pingReply;
        private int regCounter = 0;
        private OpenFileDialog file;
        private List<Register> registers = new List<Register>();
        private static string path = System.Environment.CurrentDirectory;

        public void ExecuteUpdater()
        {
            hasExe = false;
            Console.Clear();
            Console.WriteLine("Select the folder of the deployment Files [Note: select the US or CA folder]");

            folderLocation = new FolderBrowserDialog();
            folderLocation.ShowDialog();
            
            while (!pingSuccessful)
            {
                Console.Clear();
                    //single lab response
                Console.WriteLine("Enter 4 digit lab number: ");
              
                string labNumber = string.Format("{0}", Console.ReadLine());

                Console.WriteLine("Enter Number of Regs");

                string max = Console.ReadLine();

                Console.WriteLine("Is There an executable? y/n?");

                string executable = string.Format("{0}", Console.ReadLine());

                if(executable.ToLower() == "y")
                {
                    hasExe = true;
                    file = new OpenFileDialog();
                    file.ShowDialog();
                }
                else
                    hasExe = false;
                
                try
                {
                //int regs = new int();
                maxRegs = int.Parse(max);
                     labNumber = string.Format("s0{0}", labNumber);

                    pingReply = ping.Send(labNumber + "ISP000");
                    pingSuccessful = true;
                    Console.WriteLine("Success!!!");
                    Console.WriteLine(string.Format("Confirm Folder Location: {0}", folderLocation.SelectedPath));

                }
                catch (Exception exception)
                {
                    pingSuccessful = false;
                    MessageBox.Show(string.Format("{0} Please Check your store Number", exception.Message));

                }
                if (pingSuccessful)
                    {
                        for (int i = 0; i < maxRegs; i++)
                        {
                            
                        try
                        {




                            if (i == 0)
                            {
                                
                                pingReply = ping.Send(labNumber + "ISP00" + i);
                                Register reg = new Register();
                                reg.RegName = labNumber + "ISP00" + i.ToString();
                                reg.RegNo = i.ToString();
                                registers.Add(reg);
                            }
                            else
                            {
                                
                                pingReply = ping.Send(labNumber + "REG00" + i);
                                Register reg = new Register();
                                reg.RegName = labNumber + "REG00" + i.ToString();
                                reg.RegNo = i.ToString();
                                registers.Add(reg);

                            }

                            
                            
                            regCounter++;
                           
                           
                            
                            
                            Console.WriteLine(registers[i].RegName);
                        }
                        catch (Exception exception)
                        {
                            MessageBox.Show(exception.Message);
                            continue;
                        }
                        }
                    }
                Console.WriteLine("number of Regs Found: "+(regCounter).ToString());
                }
            

            //Edit Batch File nextif
            if(registers != null)
                BatchEditor.Editor(registers, folderLocation.SelectedPath, hasExe, file);
            else
                MessageBox.Show("no registers??");
            
            
            Console.WriteLine("finished!");
            Console.ReadLine();

        }

        public void UpdateAll()
        {
            Console.Clear();
            Console.WriteLine("Select the folder of the deployment Files");

            folderLocation = new FolderBrowserDialog();
            folderLocation.ShowDialog();

            Console.Write("Version Number: ");
            string versionNumber = Console.ReadLine();

            //Update Project Location with Build Path and Version Number
            string text = File.ReadAllText(string.Format("{0}", (path + @"\Batches\PROJECTLOCATION.bat")));
            text = text.Replace("xxx", folderLocation.SelectedPath);
            text = text.Replace("VER", versionNumber);
            File.WriteAllText(string.Format("{0}", (path + @"\Batches\PROJECTLOCATION.bat")), text);
            
            //Prep Update Machine Batch File
            text = "";
            text = File.ReadAllText(path + @"\Batches\UPDATE_MACHINES.bat");

            //Ask for Exclusions, process notepad and build a string list of labs numbers
            Console.WriteLine("Upload text file of labs to exclude");
            Thread.Sleep(1000);
            OpenFileDialog exclusionList = new OpenFileDialog();
            exclusionList.ShowDialog();
            List<string> exclude = File.ReadAllLines(exclusionList.FileName).ToList();
            
            //Remove exclusions from the Update Machine Batch file
            foreach (var lab in exclude)
            {
                //string machine = File.ReadAllText(string.Format("{0}", (path + @"\Batches\UPDATE_MACHINE.bat")));
                text = text.Replace(String.Format(@"start  %var%\Batches\{0}.bat >> %logfile%", lab), String.Format(""));
                //Thread.Sleep(1000);
            }
            File.WriteAllText(string.Format("{0}", (path + @"\Batches\UPDATE_MACHINES.bat")), text);

            updateBatchDirectory();
            Console.ReadLine();

        }

        private void updateBatchDirectory()
        {
            System.Diagnostics.Process.Start(path+@"\Batches\UPDATE_MACHINES.bat");

        }
    }
}
