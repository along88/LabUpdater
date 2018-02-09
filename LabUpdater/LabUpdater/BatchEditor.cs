using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LabUpdater
{
    public static class BatchEditor
    {
        private static string path = System.Environment.CurrentDirectory;
        private static string labText = string.Format("LAB");
        private static string[] regText = new string[2];
        private static string[] filePaths = { string.Format("{0}", (path + @"\ExitAptos.bat")) ,string.Format("{0}", (path + @"\StopServices.bat")), string.Format("{0}", (path + @"\StartServices.bat")), string.Format("{0}", (path + @"\CopyFiles.bat")), string.Format("{0}", (path + @"\Reboot.bat")) };
        private static string executePath = string.Format("{0}", (path + @"\Execute.bat"));
        private static bool hasExe;

        //private Stream batchFile;
        public static void Editor(List<Register> regs, string filePath, bool hasExecutable, OpenFileDialog execute)
        {
            hasExe = hasExecutable;
            regText[0] = "regNum1";
            regText[1] = "regNum2";

            //set file Path in CopyFiles.Bat file
            string text = File.ReadAllText(path+@"\CopyFiles.bat");
            text = text.Replace("xxx", filePath);
            File.WriteAllText(path+@"\CopyFiles.bat", text);
            if (hasExe)
                ExecuteBatchEditor(regs[0], execute.SafeFileName);
            try
            {
                foreach (var reg in regs)
                {
                    if (reg != null)
                    {
                        if (reg.RegNo == "0")
                            BatchFileEditor(labText, reg, filePaths);
                        else if (reg.RegNo == "1")
                            BatchFileEditor(regText[0], reg, filePaths);
                        else
                            BatchFileEditor(regText[1], reg, filePaths);
                    }
                }
                RunBatchFiles();
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
            }
        }

        private static void BatchFileEditor(string wordToReplace, Register reg,string[] batchFilePaths)
        {
            foreach (var path in batchFilePaths)
            {
                string text = File.ReadAllText(path);
                text = text.Replace(wordToReplace, reg.RegName);
                File.WriteAllText(path, text);
            }
            
        }

        private static void ExecuteBatchEditor(Register isp, string executableFileName)
        {
            string text = File.ReadAllText(executePath);
            text = text.Replace("xxx", executableFileName);
            text = text.Replace("LAB", isp.RegName);
            File.WriteAllText(executePath, text);
        }

        private static void RunBatchFiles()
        {
            //exit Aptos
            Console.WriteLine("Closing Aptos...");
            System.Security.SecureString PW = new System.Security.SecureString();
            System.Diagnostics.Process.Start(path + @"\ExitAptos.bat");
            Thread.Sleep(TimeSpan.FromMinutes(0.5));

            ////Stop Services
            Console.WriteLine("Stopping services...");
            System.Diagnostics.Process.Start(path + @"\StopServices.bat");
            Thread.Sleep(TimeSpan.FromMinutes(2.5));

            ////So nice do it twice
            System.Diagnostics.Process.Start(path + @"\StopServices.bat");
            Thread.Sleep(TimeSpan.FromMinutes(1.0));


            //Copy Files
            Console.WriteLine("Copying Files...");
            System.Diagnostics.Process.Start(path + @"\CopyFiles.bat");
            Thread.Sleep(TimeSpan.FromMinutes(1.5));


            //Start Services
            Console.WriteLine("Starting Services.Please Wait...");
            System.Diagnostics.Process.Start(path + @"\StartServices.bat");
            //Thread.Sleep(120000);
            Thread.Sleep(TimeSpan.FromMinutes(3.0));

            //If exe file exist
            if (hasExe)
            {
                Console.WriteLine("Running Executable");
                System.Diagnostics.Process.Start(executePath);
                Thread.Sleep(TimeSpan.FromMinutes(5.0));
            }
            //reboot
            Console.WriteLine("Rebooting....");
            System.Diagnostics.Process.Start(path + @"\Reboot.bat");

        }
    }

}
