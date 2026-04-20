$rawLog = @"
PASTE_YOUR_LOGS_HERE
"@

if (Test-Path "c:\dev\KeyRay\.cursor\scripts\test-macro.txt") {
    # We can use the original raw log from the previous run if we read it from the file, but wait, we don't have it.
    # I will just use a dummy text or ask the user to run it.
}

$csharpCode = @"
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;

public class FastCompressor {
    public static string RunBPE(string text, int maxIterations, bool isMeta, ref int varIdx, ArrayList legend) {
        string base62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        Regex metaSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+)|![0-9]+)");
        Regex normalSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+))");
        Regex metaTokenizer = new Regex(@"#[a-zA-Z0-9]+|[A-Za-z0-9_]+|[^A-Za-z0-9_#]+");
        Regex normalTokenizer = new Regex(@"[A-Za-z0-9_]+|[^A-Za-z0-9_]+");
        
        for (int iter = 0; iter < maxIterations; iter++) {
            var substringCounts = new Dictionary<string, int>();
            string[] parts = isMeta ? metaSplit.Split(text) : normalSplit.Split(text);
            Regex tokenizer = isMeta ? metaTokenizer : normalTokenizer;
            
            foreach (string part in parts) {
                if (string.IsNullOrEmpty(part)) continue;
                if (isMeta && metaSplit.IsMatch(part) && part == metaSplit.Match(part).Value) continue;
                if (!isMeta && normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) continue;
                
                MatchCollection matches = tokenizer.Matches(part);
                int len = matches.Count;
                string[] tokens = new string[len];
                for (int i = 0; i < len; i++) tokens[i] = matches[i].Value;
                
                int maxN = Math.Min(20, len);
                for (int n = 2; n <= maxN; n++) {
                    for (int i = 0; i <= len - n; i++) {
                        StringBuilder sb = new StringBuilder();
                        for(int j=0; j<n; j++) sb.Append(tokens[i+j]);
                        string phrase = sb.ToString();
                        
                        if (phrase.Contains("\n") || phrase.Contains("\r")) continue;
                        if (phrase.Trim().Length < (isMeta ? 5 : 4)) continue;
                        if (isMeta && !phrase.Contains("#")) continue;
                        
                        if (substringCounts.ContainsKey(phrase)) {
                            substringCounts[phrase]++;
                        } else {
                            substringCounts[phrase] = 1;
                        }
                    }
                }
            }
            
            string bestPhrase = null;
            int bestSavings = 0;
            
            foreach (var kv in substringCounts) {
                if (kv.Value > 1) {
                    int tagLen = isMeta ? (varIdx.ToString().Length + 1) : (varIdx > 61 ? 3 : 2);
                    int savings = kv.Value * (kv.Key.Length - tagLen) - (tagLen + 3 + kv.Key.Length);
                    if (savings > bestSavings) {
                        bestSavings = savings;
                        bestPhrase = kv.Key;
                    }
                }
            }
            
            if (bestSavings < 5) break;
            
            string token = "";
            if (isMeta) {
                token = "!" + varIdx;
                varIdx++;
            } else {
                int num = varIdx++;
                if (num == 0) token = "#0";
                else {
                    string res = "";
                    int n = num;
                    while (n > 0) {
                        res = base62[n % 62] + res;
                        n /= 62;
                    }
                    token = "#" + res;
                }
            }
            
            string escaped = Regex.Escape(bestPhrase);
            if (Regex.IsMatch(bestPhrase[0].ToString(), @"^[A-Za-z0-9_]$")) escaped = @"(?<![A-Za-z0-9_])" + escaped;
            if (Regex.IsMatch(bestPhrase[bestPhrase.Length-1].ToString(), @"^[A-Za-z0-9_]$")) escaped = escaped + @"(?![A-Za-z0-9_])";
            
            StringBuilder newText = new StringBuilder();
            foreach (string part in parts) {
                if (isMeta && metaSplit.IsMatch(part) && part == metaSplit.Match(part).Value) {
                    newText.Append(part);
                } else if (!isMeta && normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) {
                    newText.Append(part);
                } else {
                    newText.Append(Regex.Replace(part, escaped, token));
                }
            }
            text = newText.ToString();
            
            string displayPhrase = bestPhrase;
            if (displayPhrase.StartsWith(" ") || displayPhrase.EndsWith(" ")) displayPhrase = "'" + displayPhrase + "'";
            legend.Add(token + " = " + displayPhrase);
        }
        return text;
    }
}
"@

try {
    Add-Type -TypeDefinition $csharpCode -Language CSharp
    Write-Host "C# code compiled successfully." -ForegroundColor Green
} catch {
    Write-Host "Error compiling C# code: $_" -ForegroundColor Red
}
